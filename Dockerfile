FROM ruby:3.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /freeletics_bowling_game
WORKDIR /freeletics_bowling_game
ADD Gemfile /freeletics_bowling_game/Gemfile
ADD Gemfile.lock /freeletics_bowling_game/Gemfile.lock
RUN bundle install
ADD . /freeletics_bowling_game