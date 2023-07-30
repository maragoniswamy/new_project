# Use the official Nginx image as the base image
FROM nginx:latest

# Copy custom configuration (if needed)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose the port on which Nginx listens (default is 80)
EXPOSE 80
