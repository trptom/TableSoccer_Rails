module GamesHelper

  def get_preferred_game_type(atts)
    if !atts.kind_of?(Hash)
      atts = Hash.new
    end

    if (atts && atts[:game] && atts[:game].kind_of?(Game))
      atts[:game_number] = atts[:game].game_number
    end

    if (atts[:game_number] == 3)||
        (atts[:game_number] == 4)||
        (atts[:game_number] == 10)
      return GAME_TYPE_SINGLE
    end
    if (atts[:game_number] == 5)
      return GAME_TYPE_FOURS
    end

    return GAME_TYPE_DOUBLE
  end

  def add_players(game, p_home, p_away)
    res = true
    
    for p1 in p_home
      res =GamePlayer.new(
        :position => nil,
        :team => TEAM_HOME,
        :game_id => game.id,
        :player_id => p1
      ).save && res
    end
    
    for p2 in p_away
      res = GamePlayer.new(
        :position => nil,
        :team => TEAM_AWAY,
        :game_id => game.id,
        :player_id => p2
      ).save && res
    end
    
    return res
  end
  
  def set_preferred_players(game, players)
    case game.game_number
    when 1
      if game.game_type == GAME_TYPE_DOUBLE
        return GamesHelper::add_players(game, [ players["A"], players["B"] ], [ players["1"], players["2"] ])
      end
    when 2
      if game.game_type == GAME_TYPE_DOUBLE
        return GamesHelper::add_players(game, [ players["C"], players["D"] ], [ players["3"], players["4"] ])
      end
    when 3
      if game.game_type == GAME_TYPE_SINGLE
        return GamesHelper::add_players(game, [ players["sA"] ], [ players["s1"] ])
      end
    when 4
      if game.game_type == GAME_TYPE_SINGLE
        return GamesHelper::add_players(game, [ players["sB"] ], [ players["s2"] ])
      end
    when 5
      if game.game_type == GAME_TYPE_FOURS
        return GamesHelper::add_players(game, 
          [ players["A"], players["B"], players["C"], players["D"] ],
          [ players["1"], players["2"], players["3"], players["4"] ])
      end
      # 2 ball not implemented - i dont know which players to choose
    when 6
      if game.game_type == GAME_TYPE_DOUBLE
        return GamesHelper::add_players(game, [ players["A"], players["D"] ], [ players["1"], players["3"] ])
      end
    when 7
      if game.game_type == GAME_TYPE_DOUBLE
        return GamesHelper::add_players(game, [ players["B"], players["C"] ], [ players["2"], players["4"] ])
      end
    when 8
      if game.game_type == GAME_TYPE_DOUBLE
        return GamesHelper::add_players(game, [ players["A"], players["C"] ], [ players["2"], players["3"] ])
      end
    when 9
      if game.game_type == GAME_TYPE_DOUBLE
        return GamesHelper::add_players(game, [ players["B"], players["D"] ], [ players["1"], players["4"] ])
      end
    when 10
      if game.game_type == GAME_TYPE_SINGLE
        return GamesHelper::add_players(game, [ players["sC"] ], [ players["s3"] ])
      end
    when 11
      # 11th game not implemented - i dont know which players to choose
    else
    end
    
    return false
  end
end
