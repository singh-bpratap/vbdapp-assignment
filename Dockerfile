FROM ruby:2.7.1

# Install dependencies.
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs


# Working directory.
RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Script run when container first starts.
COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT ["/app/docker-entrypoint.sh"]

CMD ["rails", "start"]