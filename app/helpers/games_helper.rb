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

  def set_preferred_players(game, players)
    
  end
end
