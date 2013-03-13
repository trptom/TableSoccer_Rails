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
      ret << [player.nick, player.id]
    end
    if ret.length == 0
      ret << [ "Žádný hráč", nil ]
    end
    return ret
  end

  def get_game_type_options
    ret = Array.new
    ret << [ GAME_TYPE_STR[GAME_TYPE_SINGLE], GAME_TYPE_SINGLE ]
    ret << [ GAME_TYPE_STR[GAME_TYPE_DOUBLE], GAME_TYPE_DOUBLE ]
    ret << [ GAME_TYPE_STR[GAME_TYPE_TWO_BALL], GAME_TYPE_TWO_BALL ]
    ret << [ GAME_TYPE_STR[GAME_TYPE_FOURS], GAME_TYPE_FOURS ]
    return ret
  end
end
