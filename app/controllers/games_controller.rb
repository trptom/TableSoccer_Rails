# coding:utf-8

class GamesController < ApplicationController
  before_filter :require_admin
  
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
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def edit
    @game = Game.find(params[:id])
    
    respond_to do |format|
      format.html {
        @buttons = [
          { :body => I18n.t("messages.games.form.back_to_detail"), :url => @game , :html_options => {} }
        ]
      }
    end
  end

  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html {
          redirect_to @game, notice: I18n.t("messages.games.update.success")
        }
      else
        format.html {
          @errors = @game.errors
          render action: "edit"
        }
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
