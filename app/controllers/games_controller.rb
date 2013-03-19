# coding:utf-8

class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])

    @home_players = @game.game_players.where(:team => TEAM_HOME).all
    @away_players = @game.game_players.where(:team => TEAM_AWAY).all

    @home_players_list = Player.where(:team_id => @game.match.team_home_id)
    @away_players_list = Player.where(:team_id => @game.match.team_away_id)

    @new_home_player = GamePlayer.new
    @new_away_player = GamePlayer.new
    @new_home_player.game = @game
    @new_home_player.team = TEAM_HOME;
    @new_away_player.game = @game
    @new_away_player.team = TEAM_AWAY;
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Hra byla úspěšně upravena.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @match = @game.match
    @game.destroy

    respond_to do |format|
      format.html { redirect_to @match }
    end
  end
end
