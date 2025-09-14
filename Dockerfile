ARG BUILD_FROM=alpine:3.19
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    python3-dev \
    py3-pip \
    gcc \
    musl-dev \
    linux-headers \
    sqlite \
    nginx \
    curl \
    py3-virtualenv


# Create app directory
WORKDIR /app

# Set up virtualenv
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

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
    echo "Pillow==10.0.0" >> requirements.txt

# Install Python dependencies in virtualenv
RUN /venv/bin/pip install --no-cache-dir -r requirements.txt

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
