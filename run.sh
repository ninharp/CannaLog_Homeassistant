#!/bin/bash

# Set up environment variables (robust for local and HA)
if [ -z "$SECRET_KEY" ]; then
    if command -v bashio >/dev/null 2>&1; then
        SECRET_KEY=$(bashio::config 'secret_key')
    else
        SECRET_KEY="dev-secret-key"
    fi
fi
export SECRET_KEY
echo "DEBUG: run.sh SECRET_KEY is: $SECRET_KEY"

if [ -z "$DEBUG" ]; then
    if command -v bashio >/dev/null 2>&1; then
        DEBUG=$(bashio::config 'debug')
    else
        DEBUG="0"
    fi
fi
export DEBUG
export FLASK_APP=run.py

# Create symlinks for persistent data
if [ ! -L "/app/cannalog.db" ]; then
    if [ -f "/share/cannalog/database/cannalog.db" ]; then
        ln -sf "/share/cannalog/database/cannalog.db" "/app/cannalog.db"
    else
        # Initialize database if it doesn't exist
        cd /app
    /venv/bin/python -c "from app import db; db.create_all()" || true
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
EOF

bashio::log.info "Starting CannaLog..."

# Change to app directory
cd /app

# Initialize database if needed
/venv/bin/python -c "
from app import app, db
with app.app_context():
    try:
        db.create_all()
        print('Database tables created successfully')
        
        # Create default admin user if none exists
        from app.models import User
        from werkzeug.security import generate_password_hash
        if not User.query.first():
            admin = User(
                username='admin',
                password=generate_password_hash('admin123')
            )
            db.session.add(admin)
            db.session.commit()
            print('Default admin user created: admin/admin123')
        else:
            print('Users already exist, skipping admin creation')
            
    except Exception as e:
        print(f'Database initialization error: {e}')
" || bashio::log.warning "Database initialization completed with warnings"

# Set proper permissions
chown -R root:root /app
chmod -R 755 /app
chmod -R 777 /share/cannalog

bashio::log.info "CannaLog configuration complete. Starting application..."

# Start the Flask application with gunicorn from virtualenv
exec /venv/bin/gunicorn --bind 0.0.0.0:5000 --workers 2 --timeout 120 --access-logfile - --error-logfile - run:app