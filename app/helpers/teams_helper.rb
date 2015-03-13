module TeamsHelper
  def get_money_array(team, amount, from, to)
    players = team.players.all
    games_sum = 0
    ret = []
    
    # count games for each players
    for player in players
      obj = {
        :id  => player.id,
        :total_games => Game.by_player_and_time(player.id, from, to).count,
        :amount => 0,
        :formatted => nil
      }
      ret << obj
      
      games_sum = games_sum + obj[:total_games];
    end
    
    # recount amount for all players
    if games_sum == 0
      for item1 in ret
        item1[:amount] = (amount / players.count).round(2)
      end
    else
      for item2 in ret
        item2[:amount] = item2[:total_games] > 0 ?
          (item2[:total_games] * (amount / games_sum)).round(2) : 0
      end
    end
    
    # create strings of amount for all players
    for item3 in ret
      item3[:formatted] = format_amount(item3[:amount])
    end
    
    return ret
  end
  
  def get_bounding_matches_of_last_season
    if Match.count == 0
      return nil
    end
    
    last = Match.order(:start_date).last
    first = Match.where(:season => last.season).order(:start_date).first
    
    return {
      :first => first,
      :last => last
    }
  end
end
