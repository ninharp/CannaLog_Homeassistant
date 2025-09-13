#!/usr/bin/with-contenv bashio

# Get options from Home Assistant
SECRET_KEY=$(bashio::config 'secret_key')
DEBUG=$(bashio::config 'debug')

# Set up environment variables
export SECRET_KEY
export DEBUG
export FLASK_APP=run.py

# Create symlinks for persistent data
if [ ! -L "/app/cannalog.db" ]; then
    if [ -f "/share/cannalog/database/cannalog.db" ]; then
        ln -sf "/share/cannalog/database/cannalog.db" "/app/cannalog.db"
    else
        # Initialize database if it doesn't exist
        cd /app
        python3 -c "from app import db; db.create_all()" || true
        mv cannalog.db "/share/cannalog/database/cannalog.db" 2>/dev/null || true
        ln -sf "/share/cannalog/database/cannalog.db" "/app/cannalog.db"
    fi
fi

# Set up uploads directory
if [ ! -L "/app/app/static/uploads" ]; then
    rm -rf "/app/app/static/uploads" 2>/dev/null || true
    ln -sf "/share/cannalog/uploads" "/app/app/static/uploads"
fi

# Update app configuration for Home Assistant
cat > /app/app_config.py << EOF
import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', '$SECRET_KEY')
    SQLALCHEMY_DATABASE_URI = 'sqlite:///cannalog.db'
    UPLOAD_FOLDER = os.path.abspath(os.path.join(os.path.dirname(__file__), 'app', 'static', 'uploads'))
    MAX_CONTENT_LENGTH = 20 * 1024 * 1024  # 20MB max upload
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    # Home Assistant Ingress configuration
    APPLICATION_ROOT = '/api/hassio_ingress/'
    PREFERRED_URL_SCHEME = 'http'
EOF

# Modify the Flask app to work with Home Assistant Ingress
cat > /app/app/__init__.py << 'EOF'
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_migrate import Migrate
import os

app = Flask(__name__)

# Configuration
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'your-secret-key')
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///cannalog.db'
app.config['UPLOAD_FOLDER'] = os.path.abspath(os.path.join(os.path.dirname(__file__), 'static', 'uploads'))
app.config['MAX_CONTENT_LENGTH'] = 20 * 1024 * 1024  # 20MB max upload
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Home Assistant Ingress support
if os.environ.get('HASSIO_TOKEN'):
    app.config['APPLICATION_ROOT'] = '/api/hassio_ingress/'
    app.config['PREFERRED_URL_SCHEME'] = 'http'

db = SQLAlchemy(app)
migrate = Migrate(app, db)
login_manager = LoginManager(app)
login_manager.login_view = 'login'

from app import routes, models

# Create a default admin user if none exists
@app.before_first_request
def create_admin_user():
    with app.app_context():
        from app.models import User
        from werkzeug.security import generate_password_hash
        if not User.query.first():
            admin = User(
                username='admin',
                email='admin@cannalog.local',
                password_hash=generate_password_hash('admin123'),
                is_admin=True
            )
            db.session.add(admin)
            db.session.commit()
EOF

bashio::log.info "Starting CannaLog..."

# Change to app directory
cd /app

# Initialize database if needed
python3 -c "
from app import app, db
with app.app_context():
    db.create_all()
" || bashio::log.warning "Database already exists or initialization failed"

# Set proper permissions
chown -R root:root /app
chmod -R 755 /app
chmod -R 777 /share/cannalog

bashio::log.info "CannaLog configuration complete. Starting application..."

# Start the Flask application with gunicorn
exec gunicorn --bind 0.0.0.0:5000 --workers 2 --timeout 120 --access-logfile - --error-logfile - run:app