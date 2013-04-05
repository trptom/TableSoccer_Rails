module StatsHelper
  def generate_player_stats_model
    stat_types = [:gp, :w, :l, :gf, :ga, :percentage, :rate]

    stats = Array.new
    stats[GAME_TYPE_SINGLE] = {}
    stats[GAME_TYPE_DOUBLE] = {}
    stats[GAME_TYPE_FOURS] = {}
    stats[GAME_TYPE_TWO_BALL] = {}
    stats[GAME_TYPE_STR.length] = {}

    stats[GAME_TYPE_SINGLE][:game_type] = GAME_TYPE_SINGLE
    stats[GAME_TYPE_DOUBLE][:game_type] = GAME_TYPE_DOUBLE
    stats[GAME_TYPE_FOURS][:game_type] = GAME_TYPE_FOURS
    stats[GAME_TYPE_TWO_BALL][:game_type] = GAME_TYPE_TWO_BALL
    stats[GAME_TYPE_STR.length][:game_type] = GAME_TYPE_STR.length

    stat_types.each{|a|
      stats[GAME_TYPE_SINGLE][a] = 0
      stats[GAME_TYPE_DOUBLE][a] = 0
      stats[GAME_TYPE_FOURS][a] = 0
      stats[GAME_TYPE_TWO_BALL][a] = 0
      stats[GAME_TYPE_STR.length][a] = 0
    }

    return stats
  end

  def create_player_stats(player)
    stats = generate_player_stats_model

    for gp in player.game_players.all
      if (gp.game && gp.game.score_home && gp.game.score_away)
        stats[GAME_TYPE_STR.length][:gp] += 1;
        stats[gp.game.game_type][:gp] += 1;
        diff = gp.game.score_home - gp.game.score_away
        if gp.team == TEAM_HOME
          stats[GAME_TYPE_STR.length][:gf] += gp.game.score_home;
          stats[GAME_TYPE_STR.length][:ga] += gp.game.score_away;
          stats[gp.game.game_type][:gf] += gp.game.score_home;
          stats[gp.game.game_type][:ga] += gp.game.score_away;
          if diff > 0
            stats[GAME_TYPE_STR.length][:w] += 1
            stats[gp.game.game_type][:w] += 1
          end
          if diff == 0
            stats[GAME_TYPE_STR.length][:t] += 1
            stats[gp.game.game_type][:t] += 1
          end
          if diff < 0
            stats[GAME_TYPE_STR.length][:l] += 1
            stats[gp.game.game_type][:l] += 1
          end
        end
        if gp.team == TEAM_AWAY
          stats[GAME_TYPE_STR.length][:ga] += gp.game.score_home;
          stats[GAME_TYPE_STR.length][:gf] += gp.game.score_away;
          stats[gp.game.game_type][:ga] += gp.game.score_home;
          stats[gp.game.game_type][:gf] += gp.game.score_away;
          if diff < 0
            stats[GAME_TYPE_STR.length][:w] += 1
            stats[gp.game.game_type][:w] += 1
          end
          if diff == 0
            stats[GAME_TYPE_STR.length][:t] += 1
            stats[gp.game.game_type][:t] += 1
          end
          if diff > 0
            stats[GAME_TYPE_STR.length][:l] += 1
            stats[gp.game.game_type][:l] += 1
          end
        end
      end
    end

    stats[GAME_TYPE_STR.length][:rate] = stats[GAME_TYPE_STR.length][:gp] > 0 ? stats[GAME_TYPE_STR.length][:w].to_f/stats[GAME_TYPE_STR.length][:gp].to_f : 0;
    stats[GAME_TYPE_SINGLE][:rate] = stats[GAME_TYPE_SINGLE][:gp] > 0 ? stats[GAME_TYPE_SINGLE][:w].to_f/stats[GAME_TYPE_SINGLE][:gp].to_f : 0;
    stats[GAME_TYPE_DOUBLE][:rate] = stats[GAME_TYPE_DOUBLE][:gp] > 0 ? stats[GAME_TYPE_DOUBLE][:w].to_f/stats[GAME_TYPE_DOUBLE][:gp].to_f : 0;
    stats[GAME_TYPE_FOURS][:rate] = stats[GAME_TYPE_FOURS][:gp] > 0 ? stats[GAME_TYPE_FOURS][:w].to_f/stats[GAME_TYPE_FOURS][:gp].to_f : 0;
    stats[GAME_TYPE_TWO_BALL][:rate] = stats[GAME_TYPE_TWO_BALL][:gp] > 0 ? stats[GAME_TYPE_TWO_BALL][:w].to_f/stats[GAME_TYPE_TWO_BALL][:gp].to_f : 0;

    stats[GAME_TYPE_STR.length][:percentage] = sprintf('%.2f', stats[GAME_TYPE_STR.length][:rate]*100)
    stats[GAME_TYPE_SINGLE][:percentage] = sprintf('%.2f', stats[GAME_TYPE_SINGLE][:rate]*100)
    stats[GAME_TYPE_DOUBLE][:percentage] = sprintf('%.2f', stats[GAME_TYPE_DOUBLE][:rate]*100)
    stats[GAME_TYPE_FOURS][:percentage] = sprintf('%.2f', stats[GAME_TYPE_FOURS][:rate]*100)
    stats[GAME_TYPE_TWO_BALL][:percentage] = sprintf('%.2f', stats[GAME_TYPE_TWO_BALL][:rate]*100)

    return stats
  end
end
