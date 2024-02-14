# README

This project contains the Freeletics bowling game app. This is a Ruby on Rails 7 project.

The api contains endpoints to create a game, roll a game and get the score of the game

  ```sh
create_game POST /games(.:format)  games#create
roll_game POST /games/:id/roll(.:format)  games#roll
score_game GET  /games/:id/score(.:format) games#score
  ```

You need:
* Docker & docker-compose
* Ruby 3.3.0

## Build the environment

  ```sh
  docker-compose build
  ```

## Database creation

  ```sh
  docker-compose run backend bundle exec rake db:setup
  ```

## Start the environment

  ```sh
  docker-compose up
  ```

## Working with the Rails container

  ```sh
  docker-compose exec backend bash
  ```

## Tests

  ```sh
  rspec
  ```
