# coding:utf-8

module ApplicationHelper
  def get_team_options
    tmp = Team.all
    ret = Array.new
    for team in tmp
      ret << [team.name, team.id]
    end
    if ret.length == 0
      ret << [ "Žádný tým", nil]
    end
    return ret
  end

  def get_league_options
    tmp = League.all
    ret = Array.new
    for league in tmp
      ret << [league.name, league.id]
    end
    if ret.length == 0
      ret << [ "Žádná liga", nil ]
    end
    return ret
  end

  def get_match_options
    tmp = Match.order(:start_date).all
    ret = Array.new
    for match in tmp
      ret << [match.start_date + ", " + match.team_home.name + " vs. " + match.team_away.name, match.id]
    end
    if ret.length == 0
      ret << [ "Žádný zápas", nil ]
    end
    return ret
  end

  def get_player_options(team_id)
    tmp = team_id ? Player.where(:team_id => team_id).order(:nick).all : Player.order(:nick).all
    ret = Array.new
    for player in tmp
      ret << [get_player_name(player), player.id]
    end
    if ret.length == 0
      ret << [ "Žádný hráč", nil ]
    end
    return ret
  end

  def get_game_type_options
    ret = Array.new
    ret << [ GAME_TYPE_STR[GAME_TYPE_SINGLE], GAME_TYPE_SINGLE.to_s ]
    ret << [ GAME_TYPE_STR[GAME_TYPE_DOUBLE], GAME_TYPE_DOUBLE.to_s ]
    ret << [ GAME_TYPE_STR[GAME_TYPE_TWO_BALL], GAME_TYPE_TWO_BALL.to_s ]
    ret << [ GAME_TYPE_STR[GAME_TYPE_FOURS], GAME_TYPE_FOURS.to_s ]
    return ret
  end

  def get_current_user_player
    return current_user ? current_user.player : nil
  end

  def get_current_user_team
    player = get_current_user_player
    return player ? player.team : nil
  end

  def get_player_name(player)
    if player.nick
      return player.nick
    else
      if player.first_name && player.second_name
        return player.first_name + " " + player.second_name
      else
        if (player.second_name)
          return player.second_name
        end
        if (player.first_name)
          return player.first_name
        end
      end
    end
  end
end
