# coding:utf-8

class GamePlayersController < ActionController::Base
  before_filter :require_login
  
  def create
    @game_player = GamePlayer.new(params[:game_player])
    @game_player.save

    respond_to do |format|
      format.html { redirect_to @game_player.game }
    end
  end

  def destroy
    @game_player = GamePlayer.find(params[:id])
    @game = @game_player.game
    @game_player.destroy

    respond_to do |format|
      format.html { redirect_to @game }
    end
  end
end
