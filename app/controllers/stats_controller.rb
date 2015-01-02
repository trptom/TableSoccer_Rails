# coding:utf-8

include StatsHelper

# Controller for all Stats screens.
class StatsController < ApplicationController
  
  # Shows stats of all players within one team.
  #
  # ==== Required params
  # _id_:: id of _Team_ for which players stats should be shown.
  # _season_:: number of season for which stats should be shown. Not required.
  # When not sent, summary of all seasons is shown.
  #
  # ==== Format
  # * HTML
  def players
    #load all teams
    @teams = Team.order(:name).all
    #load selected team
    if params[:id]
      @team = Team.find(params[:id])
    else
      @team = current_user && current_user.player && current_user.player.team ? current_user.player.team : Team.first
    end

    if @team
      @players = Player.find_all_by_team_id @team.id
      @player_info = Array.new

      for player in @players
        gp_list = params[:season] && params[:season] != "" ?
          player.game_players.by_season(params[:season].to_i) :
          player.game_players
        
        tmp = Hash.new
        tmp[:player] = player;
        tmp[:games_count] = gp_list.length

        tmp[:gp] = 0;
        tmp[:gf] = 0;
        tmp[:ga] = 0;
        tmp[:w] = 0;
        tmp[:t] = 0;
        tmp[:l] = 0;
        tmp[:rate] = 0;
        for gp in gp_list
          if (gp.game && gp.game.score_home && gp.game.score_away)
            tmp[:gp] += 1
            if (gp.team == TEAM_HOME)
              tmp[:gf] += gp.game.score_home;
              tmp[:ga] += gp.game.score_away;
              diff = gp.game.score_home - gp.game.score_away
              if diff > 0
                tmp[:w] += 1
              end
              if diff == 0
                tmp[:t] += 1
              end
              if diff < 0
                tmp[:l] += 1
              end
            end
            if (gp.team == TEAM_AWAY)
              tmp[:ga] += gp.game.score_home;
              tmp[:gf] += gp.game.score_away;
              diff = gp.game.score_home - gp.game.score_away
              if diff < 0
                tmp[:w] += 1
              end
              if diff == 0
                tmp[:t] += 1
              end
              if diff > 0
                tmp[:l] += 1
              end
            end
          end
        end

        tmp[:rate] = tmp[:gp] > 0 ? tmp[:w].to_f/tmp[:gp].to_f : 0;
        tmp[:percentage] = sprintf('%.2f', tmp[:rate]*100)
        tmp[:score_diff] = tmp[:gf] - tmp[:ga]
        @player_info << tmp
      end
    end
  end

  def player
    #load all players
    @players = Player.all.sort{
      |a, b| get_player_name(a) <=> get_player_name(b)
    }
    #load selected player
    if params[:id]
      @player = Player.find(params[:id])
    else
      @player = current_user && current_user.player ? Player.find(current_user.player) : Player.first
    end

    if @player
      @stats = create_player_stats @player, params[:season].to_i
    end
  end

  def team
    #load all teams
    @teams = Team.order(:name).all
    #load selected team
    if params[:id]
      @team = Team.find(params[:id])
    else
      @team = current_user && current_user.player && current_user.player.team ? current_user.player.team : Team.first
    end
    
    if @team
      @stats = create_team_stats @team, params[:season].to_i
    end
  end
end
