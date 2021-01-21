# Retrieve the ruby image
FROM ruby:2.7.1

# Install basic required libs
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y libpq-dev

# Install bundler
RUN gem install bundler --version "2.1.4"

# Set an environment variable for the Rails app root folder
ENV RAILS_ROOT /var/www/vdbapp-assignment

# Create the working directory
RUN mkdir -p $RAILS_ROOT

# Set working directory
WORKDIR $RAILS_ROOT

# Set production env variables and enabling the option to serve static files
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

# Add Gemfile
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

# Install gems. -j $(nproc) runs bundle with to total amount of CPU cores/threads available
RUN bundle install -j $(nproc)

# Add Rails project files
COPY . .

# Set required environment variables.
ENV RAILS_MASTER_KEY='20fa01bc57e62506653d8d7e0a6e2c14'
ENV RAILS_SERVE_STATIC_FILES='enabled'
ENV SECRET_KEY_BASE='b67ac40503e023561db54c9fb0d65e563d6a2dbe11bfceb71140867953845a91404a50b341114ed21dfe7d927b3b42e34d2e96c230936c5f542728995f57fda7'

# Expose port 3000 to be available for NGINX reverse proxy
EXPOSE 3000

# Start the main process with Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
