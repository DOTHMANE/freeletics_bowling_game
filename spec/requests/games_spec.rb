# spec/requests/games_request_spec.rb

require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "POST /games" do
    it "creates a new game" do
      post "/games"
      expect(response).to have_http_status(:success)
      expect(Game.count).to eq(1)
    end
  end

  describe "POST /games/:id/roll" do
    let(:game) { create(:game) }

    context "when the game is not finished" do
      it "simulates a roll in the game" do
        post "/games/#{game.id}/roll", params: { knocked_pins: 5 }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to include('frames')
      end
    end

    context "when the game is finished" do
      it "returns an error response" do
        allow_any_instance_of(Game).to receive(:finished?).and_return(true)
        post "/games/#{game.id}/roll", params: { knocked_pins: 5 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error')
      end
    end

    context "when the number of knocked pins is invalid" do
      it "returns an error response" do
        post "/games/#{game.id}/roll", params: { knocked_pins: 15 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
  end

  describe "GET /games/:id/score" do
    let(:game) { create(:game) }

    it "returns the score of the game" do
      get "/games/#{game.id}/score"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include('game_score')
    end
  end
end
