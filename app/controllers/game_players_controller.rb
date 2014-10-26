# coding:utf-8

class GamePlayersController < ApplicationController
  before_filter :require_admin
  
  # Creates new connection between _Game_ and _Player_.
  #
  # ==== Required params
  # _game_player_:: contains all attributes of _GamePlayer_ which should be
  # created.
  #
  # ==== Format
  # * HTML
  def create
    @game_player = GamePlayer.new(params[:game_player])
    @game_player.save

    respond_to do |format|
      format.html { redirect_to @game_player.game }
    end
  end

  # Deletes connection between _Game_ and _Player_.
  #
  # ==== Required params
  # _id_:: id of connection that should be deleted.
  #
  # ==== Format
  # * HTML
  def destroy
    @game_player = GamePlayer.find(params[:id])
    @game = @game_player.game
    @game_player.destroy

    respond_to do |format|
      format.html { redirect_to @game }
    end
  end
end
