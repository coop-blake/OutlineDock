FROM nginx:latest

# Install OpenSSL
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

# Define the directory for SSL certificates
ENV SSL_DIR=/etc/nginx/ssl

# Create SSL directory
RUN mkdir -p $SSL_DIR

# Generate a self-signed certificate if it does not exist
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout $SSL_DIR/selfsigned.key -out $SSL_DIR/selfsigned.crt \
  -subj "/CN=blakes-macbook-pro.local"

# Copy the custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose HTTPS port
EXPOSE 443
