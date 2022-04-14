FROM ruby:2.7.2

# Install nodejs
RUN apt-get update -qq && apt-get install -y nodejs

# Update
RUN apt-get update -y


WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app/

# Install & run bundler
RUN gem install bundler:'~> 2.1.4'

RUN bundle

COPY . /usr/src/app/

EXPOSE 3000

CMD ./docker/entrypoint.sh