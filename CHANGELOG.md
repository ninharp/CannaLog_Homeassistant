# Changelog

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