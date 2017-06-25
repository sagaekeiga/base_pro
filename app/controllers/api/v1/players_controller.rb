module Api
  module V1
    class PlayersController < ApplicationController
    skip_before_filter :verify_authenticity_token

      def index
         @players = Player.all
         render json: @players
      end
      
      def search
         params = request.body.read
         logger.debug("params")
         logger.debug(params)
         logger.debug("params")
         @players = Player.where("name like '%#{params}%'") if !params.nil?
         render json: @players
      end
      
      def detail
         params = request.body.read
         logger.debug("params")
         logger.debug(params)
         logger.debug("params")
         @player = Player.find_by(name: params) if !params.nil?
         render json: @player
      end
        
    end
  end
end