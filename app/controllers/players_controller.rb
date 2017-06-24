class PlayersController < ApplicationController
    http_basic_authenticate_with name: "sagae", password: "s19930528"
    

    def index
      @players = Player.all
    end
    
    def new
        @player = Player.new
    end
    
    def create
     @player = Player.new(player_params)
     if @player.save
       redirect_to root_path
     else
       render 'laughters/new'
     end
    end
    
    def edit
      @player = Player.find(params[:id])
    end
    
    def destroy
      @player = Player.find(params[:id])
        if @player.delete
         flash[:success] = "deleted"
        end
        redirect_to root_path
    end
    
    def show
      @player = Player.find(params[:id])
    end
    
    def update
        @player = Player.find(params[:id])
        @player.update(player_params)
        redirect_to root_path
    end
    

    
      private
      
        def player_params
          params.require(:player).permit(:name, :image, :country, :graduate, :birth, :height, :weight, :style, :position, :draft, :bar, :career, :phonetic, :team)
        end
end
