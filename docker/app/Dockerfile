# Retrieve the ruby image
FROM ruby:2.7.1

# Install basic required libs
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y libpq-dev

# Install bundler
RUN gem install bundler --version "2.1.4"

# Set an environment variable for the Rails app root folder
ENV RAILS_ROOT /var/www/vbdapp-assignment

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

# Expose port 3000 to be available for NGINX reverse proxy
EXPOSE 3000

# Start the main process with Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
