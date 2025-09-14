
# Changelog

## [1.0.1] - 2025-09-14

### Changed
- Switched Docker base image to `ghcr.io/home-assistant/amd64-base:3.19` for better Home Assistant compatibility
- Python and pip installation now handled via apk in Dockerfile
- All Python dependencies are now installed in a virtual environment (`venv`) to avoid PEP 668 errors
- Werkzeug version pinned to 2.3.7 for Flask-WTF compatibility

### Fixed
- Add-on now builds and runs reliably in Home Assistant and locally
- Fixed ImportError with `url_encode` from `werkzeug.urls`
- Fixed issues with bashio commands when running outside Home Assistant

## [1.0.0] - 2024-09-13

### Added
- Initial release of CannaLog Home Assistant Add-on
- Full Home Assistant Ingress integration
- Persistent data storage in `/share/cannalog/`
- Complete plant management interface
- Responsive web UI optimized for desktop and mobile
- Image upload and management functionality
- Plant and environment tracking
- Measurement logging (temperature, humidity, pH, EC, etc.)
- Action logging for plant care activities
- Two-step confirmation for critical operations

### Features
- Flask-based web application
- SQLite database for data persistence
- Bootstrap-based responsive UI
- Sidebar integration with Home Assistant
- Secure session management
- File upload support for plant images
- Multi-language support (German)

### Technical
- Docker-based deployment
- Gunicorn WSGI server
- Alpine Linux base image
- Multi-architecture support (amd64, aarch64, armhf, armv7, i386)
- Health check monitoring
- Proper permission handling