module StatsHelper
  def generate_player_stats_model
    stat_types = [:gp, :w, :t, :l, :gf, :ga, :percentage, :rate]

    stats = {
      :gt => [],
      :total => {}
    }
    stats[:gt] = Array.new
    stats[:gt][GAME_TYPE_SINGLE] = {}
    stats[:gt][GAME_TYPE_DOUBLE] = {}
    stats[:gt][GAME_TYPE_FOURS] = {}
    stats[:gt][GAME_TYPE_TWO_BALL] = {}

    stats[:gt][GAME_TYPE_SINGLE][:game_type] = GAME_TYPE_SINGLE
    stats[:gt][GAME_TYPE_DOUBLE][:game_type] = GAME_TYPE_DOUBLE
    stats[:gt][GAME_TYPE_FOURS][:game_type] = GAME_TYPE_FOURS
    stats[:gt][GAME_TYPE_TWO_BALL][:game_type] = GAME_TYPE_TWO_BALL

    stat_types.each{|a|
      stats[:gt][GAME_TYPE_SINGLE][a] = 0
      stats[:gt][GAME_TYPE_DOUBLE][a] = 0
      stats[:gt][GAME_TYPE_FOURS][a] = 0
      stats[:gt][GAME_TYPE_TWO_BALL][a] = 0
      stats[:total][a] = 0
    }

    return stats
  end

  def create_player_stats(player, season = nil)
    stats = generate_player_stats_model

    @source = params[:season] == nil || params[:season] == "" ?
      player.game_players.all :
      player.game_players.by_season(season).all
    
    for gp in @source
      if (gp.game && gp.game.score_home && gp.game.score_away)
        stats[:total][:gp] += 1;
        stats[:gt][gp.game.game_type][:gp] += 1;
        diff = gp.game.score_home - gp.game.score_away
        if gp.team == TEAM_HOME
          stats[:total][:gf] += gp.game.score_home;
          stats[:total][:ga] += gp.game.score_away;
          stats[:gt][gp.game.game_type][:gf] += gp.game.score_home;
          stats[:gt][gp.game.game_type][:ga] += gp.game.score_away;
          if diff > 0
            stats[:total][:w] += 1
            stats[:gt][gp.game.game_type][:w] += 1
          end
          if diff == 0
            stats[:total][:t] += 1
            stats[:gt][gp.game.game_type][:t] += 1
          end
          if diff < 0
            stats[:total][:l] += 1
            stats[:gt][gp.game.game_type][:l] += 1
          end
        end
        if gp.team == TEAM_AWAY
          stats[:total][:ga] += gp.game.score_home;
          stats[:total][:gf] += gp.game.score_away;
          stats[:gt][gp.game.game_type][:ga] += gp.game.score_home;
          stats[:gt][gp.game.game_type][:gf] += gp.game.score_away;
          if diff < 0
            stats[:total][:w] += 1
            stats[:gt][gp.game.game_type][:w] += 1
          end
          if diff == 0
            stats[:total][:t] += 1
            stats[:gt][gp.game.game_type][:t] += 1
          end
          if diff > 0
            stats[:total][:l] += 1
            stats[:gt][gp.game.game_type][:l] += 1
          end
        end
      end
    end

    stats[:total][:rate] = stats[:total][:gp] > 0 ? stats[:total][:w].to_f/stats[:total][:gp].to_f : 0;
    stats[:gt][GAME_TYPE_SINGLE][:rate] = stats[:gt][GAME_TYPE_SINGLE][:gp] > 0 ? stats[:gt][GAME_TYPE_SINGLE][:w].to_f/stats[:gt][GAME_TYPE_SINGLE][:gp].to_f : 0;
    stats[:gt][GAME_TYPE_DOUBLE][:rate] = stats[:gt][GAME_TYPE_DOUBLE][:gp] > 0 ? stats[:gt][GAME_TYPE_DOUBLE][:w].to_f/stats[:gt][GAME_TYPE_DOUBLE][:gp].to_f : 0;
    stats[:gt][GAME_TYPE_FOURS][:rate] = stats[:gt][GAME_TYPE_FOURS][:gp] > 0 ? stats[:gt][GAME_TYPE_FOURS][:w].to_f/stats[:gt][GAME_TYPE_FOURS][:gp].to_f : 0;
    stats[:gt][GAME_TYPE_TWO_BALL][:rate] = stats[:gt][GAME_TYPE_TWO_BALL][:gp] > 0 ? stats[:gt][GAME_TYPE_TWO_BALL][:w].to_f/stats[:gt][GAME_TYPE_TWO_BALL][:gp].to_f : 0;

    stats[:total][:percentage] = sprintf('%.2f', stats[:total][:rate]*100)
    stats[:gt][GAME_TYPE_SINGLE][:percentage] = sprintf('%.2f', stats[:gt][GAME_TYPE_SINGLE][:rate]*100)
    stats[:gt][GAME_TYPE_DOUBLE][:percentage] = sprintf('%.2f', stats[:gt][GAME_TYPE_DOUBLE][:rate]*100)
    stats[:gt][GAME_TYPE_FOURS][:percentage] = sprintf('%.2f', stats[:gt][GAME_TYPE_FOURS][:rate]*100)
    stats[:gt][GAME_TYPE_TWO_BALL][:percentage] = sprintf('%.2f', stats[:gt][GAME_TYPE_TWO_BALL][:rate]*100)

    return stats
  end
  
  def generate_team_stats_model
    stat_types = [:gp, :w, :t, :l, :gf, :ga, :percentage, :rate]

    stats = {
      :gt => [], # game types
      :total => {}, # summary of game types
      :combinations => {} # player combinations
    }
    stats[:gt] = Array.new
    stats[:gt][GAME_TYPE_SINGLE] = {}
    stats[:gt][GAME_TYPE_DOUBLE] = {}
    stats[:gt][GAME_TYPE_FOURS] = {}
    stats[:gt][GAME_TYPE_TWO_BALL] = {}

    stats[:gt][GAME_TYPE_SINGLE][:game_type] = GAME_TYPE_SINGLE
    stats[:gt][GAME_TYPE_DOUBLE][:game_type] = GAME_TYPE_DOUBLE
    stats[:gt][GAME_TYPE_FOURS][:game_type] = GAME_TYPE_FOURS
    stats[:gt][GAME_TYPE_TWO_BALL][:game_type] = GAME_TYPE_TWO_BALL

    stat_types.each{|a|
      stats[:gt][GAME_TYPE_SINGLE][a] = 0
      stats[:gt][GAME_TYPE_DOUBLE][a] = 0
      stats[:gt][GAME_TYPE_FOURS][a] = 0
      stats[:gt][GAME_TYPE_TWO_BALL][a] = 0
      stats[:total][a] = 0
    }

    return stats
  end
  
  def create_team_stats(team, season = nil)
    stats = generate_team_stats_model

    @source = params[:season] == nil || params[:season] == "" ?
      Match.by_team(team).all :
      Match.by_team(team).where(:season => season).all
    
    # recount stats
    for match in @source
      stats = update_team_stats(team, stats, match)
    end
    
    # update rates and totals
    stats[:total][:rate] = stats[:total][:gp] > 0 ? stats[:total][:w].to_f/stats[:total][:gp].to_f : 0;
    stats[:gt][GAME_TYPE_SINGLE][:rate] = stats[:gt][GAME_TYPE_SINGLE][:gp] > 0 ? stats[:gt][GAME_TYPE_SINGLE][:w].to_f/stats[:gt][GAME_TYPE_SINGLE][:gp].to_f : 0;
    stats[:gt][GAME_TYPE_DOUBLE][:rate] = stats[:gt][GAME_TYPE_DOUBLE][:gp] > 0 ? stats[:gt][GAME_TYPE_DOUBLE][:w].to_f/stats[:gt][GAME_TYPE_DOUBLE][:gp].to_f : 0;
    stats[:gt][GAME_TYPE_FOURS][:rate] = stats[:gt][GAME_TYPE_FOURS][:gp] > 0 ? stats[:gt][GAME_TYPE_FOURS][:w].to_f/stats[:gt][GAME_TYPE_FOURS][:gp].to_f : 0;
    stats[:gt][GAME_TYPE_TWO_BALL][:rate] = stats[:gt][GAME_TYPE_TWO_BALL][:gp] > 0 ? stats[:gt][GAME_TYPE_TWO_BALL][:w].to_f/stats[:gt][GAME_TYPE_TWO_BALL][:gp].to_f : 0;

    stats[:total][:percentage] = sprintf('%.2f', stats[:total][:rate]*100)
    stats[:gt][GAME_TYPE_SINGLE][:percentage] = sprintf('%.2f', stats[:gt][GAME_TYPE_SINGLE][:rate]*100)
    stats[:gt][GAME_TYPE_DOUBLE][:percentage] = sprintf('%.2f', stats[:gt][GAME_TYPE_DOUBLE][:rate]*100)
    stats[:gt][GAME_TYPE_FOURS][:percentage] = sprintf('%.2f', stats[:gt][GAME_TYPE_FOURS][:rate]*100)
    stats[:gt][GAME_TYPE_TWO_BALL][:percentage] = sprintf('%.2f', stats[:gt][GAME_TYPE_TWO_BALL][:rate]*100)
    
    stats[:combinations].each do |key, array|
      stats[:combinations][key][:rate] = stats[:combinations][key][:gp] > 0 ? stats[:combinations][key][:w].to_f/stats[:combinations][key][:gp].to_f : 0;
      stats[:combinations][key][:percentage] = sprintf('%.2f', stats[:combinations][key][:rate]*100)
    end
    
    return stats
  end
  
  def update_team_stats(team, stats, match)
    @team_type = match.team_type(team)
    @games = match.games
    
    for game in @games
      if game.started
        stats[:total][:gp] += 1;
        stats[:gt][game.game_type][:gp] += 1;
        diff = game.score_home - game.score_away
        
        if (@team_type == TEAM_HOME)
          players_str = game.home_players_str(", ", I18n.t("messages.base.players_not_presented"))
          if (!stats[:combinations].has_key?(players_str))
            stats[:combinations][players_str] = {
              :gp => 0,
              :w => 0,
              :t => 0,
              :l => 0,
              :gf => 0,
              :ga => 0,
              :percentage => 0,
              :rate => 0
            }
          end
          stats[:combinations][players_str][:gp] += 1;
          
          stats[:total][:gf] += game.score_home;
          stats[:total][:ga] += game.score_away;
          stats[:gt][game.game_type][:gf] += game.score_home;
          stats[:gt][game.game_type][:ga] += game.score_away;
          stats[:combinations][players_str][:gf] += game.score_home;
          stats[:combinations][players_str][:ga] += game.score_away;
          
          if diff > 0
            stats[:total][:w] += 1
            stats[:gt][game.game_type][:w] += 1
            stats[:combinations][players_str][:w] += 1
          end
          if diff == 0
            stats[:total][:t] += 1
            stats[:gt][game.game_type][:t] += 1
            stats[:combinations][players_str][:t] += 1
          end
          if diff < 0
            stats[:total][:l] += 1
            stats[:gt][game.game_type][:l] += 1
            stats[:combinations][players_str][:l] += 1
          end
        end
        
        if @team_type == TEAM_AWAY
          players_str = game.away_players_str(", ", I18n.t("messages.base.players_not_presented"))
          if (!stats[:combinations].has_key?(players_str))
            stats[:combinations][players_str] = {
              :gp => 0,
              :w => 0,
              :t => 0,
              :l => 0,
              :gf => 0,
              :ga => 0,
              :percentage => 0,
              :rate => 0
            }
          end
          stats[:combinations][players_str][:gp] += 1;
          
          stats[:total][:ga] += game.score_home;
          stats[:total][:gf] += game.score_away;
          stats[:gt][game.game_type][:ga] += game.score_home;
          stats[:gt][game.game_type][:gf] += game.score_away;
          stats[:combinations][players_str][:ga] += game.score_home;
          stats[:combinations][players_str][:gf] += game.score_away;
          
          if diff < 0
            stats[:total][:w] += 1
            stats[:gt][game.game_type][:w] += 1
            stats[:combinations][players_str][:w] += 1
          end
          if diff == 0
            stats[:total][:t] += 1
            stats[:gt][game.game_type][:t] += 1
            stats[:combinations][players_str][:t] += 1
          end
          if diff > 0
            stats[:total][:l] += 1
            stats[:gt][game.game_type][:l] += 1
            stats[:combinations][players_str][:l] += 1
          end
        end
      end
    end
    
    return stats
  end
end
