# Base image: Debian Bullseye Slim
FROM debian:bullseye-slim

# Metadata for the image
LABEL maintainer="orezek@42.fr" \
      description="Custom NGINX image with TLSv1.2 and TLSv1.3 support on Debian Bullseye"

# Update and install NGINX and required tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create required directories for TLS certificates
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Copy the custom NGINX configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose port 443 for HTTPS traffic
EXPOSE 443

# Entrypoint to run NGINX in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]
