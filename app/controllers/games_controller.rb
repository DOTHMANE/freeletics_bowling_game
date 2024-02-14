class GamesController < ApplicationController
  before_action :set_game, only: [:roll, :score]

  # POST /games
  def create
    @game = Game.create
    render json: @game
  end

  # POST /games/:id/roll
  def roll
    return render json: { error: "Game is finished" }, status: :unprocessable_entity if @game.finished?

    knocked_pins = params[:knocked_pins].to_i
    @game.roll(knocked_pins)
    render json: @game
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /games/:id/score
  def score
    render json: @game
  end

  private

  # Set the current game instance
  def set_game
    @game = Game.find(params[:id])
  end
end
