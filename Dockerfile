# Use official Ruby image
FROM ruby:3.2.2-slim

# # Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y libpq-dev build-essential nodejs npm postgresql-client git cmake && \
    rm -rf /var/lib/apt/lists/*

# # Make directory mountedapp
# RUN mkdir /mountedapp



# Set working directory
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

COPY config/database.yml config/database.yml

# Create Rails project if not existing
# RUN rails new . --database=postgresql --skip-git

# RUN ls -l

RUN bundle install

# # # Update database.yml to use environment variables
RUN sed -i 's/database: myapp_development/database: <%= ENV["POSTGRES_DB"] || "myapp_development" %>/g' config/database.yml
RUN sed -i 's/username: ~$/username: <%= ENV["POSTGRES_USER"] || "postgres" %>/g' config/database.yml
RUN sed -i 's/password: ~$/password: <%= ENV["POSTGRES_PASSWORD"] || "postgres" %>/g' config/database.yml
RUN sed -i 's/host: ~$/host: <%= ENV["POSTGRES_HOST"] || "db" %>/g' config/database.yml

# Expose port
EXPOSE 3000

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]

# CMD ["tail", "-f", "/dev/null"]

