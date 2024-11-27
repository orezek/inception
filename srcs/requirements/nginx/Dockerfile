# Base image: Debian Bullseye Slim
FROM debian:bullseye-slim

# Update and install NGINX and required tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create required directories for TLS certificates
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Copy the custom NGINX configuration its default location and override the default config
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose port 443 for HTTPS traffic - it does nothing
EXPOSE 443
EXPOSE 80

# Entrypoint to run NGINX in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]
