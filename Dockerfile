# Use the official Home Assistant Add-on Alpine base image
ARG BUILD_FROM=ghcr.io/hassio-addons/base:14.0.3
FROM $BUILD_FROM

# Install Python and pip (bashio is already included)
RUN apk add --no-cache python3 py3-pip
RUN ln -sf python3 /usr/bin/python

# Create app directory
WORKDIR /app

# Copy CannaLog application
COPY cannalog/ /app/

# Create requirements.txt with necessary dependencies
RUN echo "Flask==2.3.3" > requirements.txt && \
    echo "Flask-SQLAlchemy==3.0.5" >> requirements.txt && \
    echo "Flask-Login==0.6.3" >> requirements.txt && \
    echo "Flask-Migrate==4.0.5" >> requirements.txt && \
    echo "Flask-WTF==1.1.1" >> requirements.txt && \
    echo "WTForms==3.0.1" >> requirements.txt && \
    echo "gunicorn==21.2.0" >> requirements.txt && \
    echo "Pillow==10.0.0" >> requirements.txt && \
    echo "Werkzeug==2.3.7" >> requirements.txt && \
    echo "WeasyPrint==61.2" >> requirements.txt

# Set up virtualenv and install Python dependencies
RUN python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip install --no-cache-dir -r requirements.txt
ENV PATH="/venv/bin:$PATH"

# Create necessary directories
RUN mkdir -p /app/app/static/uploads && \
    mkdir -p /share/cannalog && \
    mkdir -p /share/cannalog/uploads && \
    mkdir -p /share/cannalog/database

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Expose port
EXPOSE 5000

# Copy build file
COPY build.yaml /


# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:5000/ || exit 1

CMD [ "/run.sh" ]
