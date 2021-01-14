# Retrieve the nginx base image
FROM nginx

# Install some dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils

# Set env variable where NGINX should look for project files
ENV RAILS_ROOT /home/rails/vdbapp-assignment

# Set working directory
WORKDIR $RAILS_ROOT

# Create log directory
RUN mkdir log

# copy over static assets
COPY public public/

# Copy Nginx config template
COPY /docker/web/nginx.conf /tmp/app.conf

EXPOSE 80

RUN envsubst '$RAILS_ROOT' < /tmp/app.conf > /etc/nginx/conf.d/default.conf

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]