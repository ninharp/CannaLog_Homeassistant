#!/usr/bin/with-contenv bashio

# Set up environment variables (robust for local and HA)
SECRET_KEY=$(bashio::config 'secret_key')
export SECRET_KEY

DEBUG=$(bashio::config 'debug')
export DEBUG

export FLASK_APP=run.py

# Ensure persistent directories exist
mkdir -p /share/cannalog/database
mkdir -p /share/cannalog/uploads

# Create symlinks for persistent data
if [ ! -L "/app/cannalog.db" ]; then
    if [ -f "/share/cannalog/database/cannalog.db" ]; then
        ln -sf "/share/cannalog/database/cannalog.db" "/app/cannalog.db"
    else
        # Initialize database if it doesn't exist
        cd /app
        /venv/bin/python <<EOF || true
from app import app, db
with app.app_context():
    db.create_all()
EOF
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
    SQLALCHEMY_DATABASE_URI = 'sqlite:////share/cannalog/database/cannalog.db'
    UPLOAD_FOLDER = os.path.abspath(os.path.join(os.path.dirname(__file__), 'app', 'static', 'uploads'))
    MAX_CONTENT_LENGTH = 20 * 1024 * 1024  # 20MB max upload
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    # Home Assistant Ingress configuration
    APPLICATION_ROOT = '/api/hassio_ingress/'
    PREFERRED_URL_SCHEME = 'http'
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
        # from app.models import User
        # from werkzeug.security import generate_password_hash
        # if not User.query.first():
        #    admin = User(
        #        username='admin',
        #        password=generate_password_hash('admin123')
        #    )
        #    db.session.add(admin)
        #    db.session.commit()
        #    print('Default admin user created: admin/admin123')
        # else:
        #    print('Users already exist, skipping admin creation')
            
    except Exception as e:
        print(f'Database initialization error: {e}')
" || bashio::log.warning "Database initialization completed with warnings"

# Set proper permissions
chown -R root:root /app
chmod -R 755 /app
chmod -R 777 /share/cannalog

bashio::log.info "CannaLog configuration complete. Starting application..."

# Start the Flask application with gunicorn from virtualenv
exec /venv/bin/gunicorn --bind 0.0.0.0:5000 --workers 1 --timeout 120 --access-logfile - --error-logfile - app:app