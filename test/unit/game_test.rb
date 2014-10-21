require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "scope by season dummy" do
    @match = Match.new(
      :season => 2099,
      :team_home_id => 2,
      :team_away_id => 1,
      :league_id => 3,
      :start_date => "2013-06-13 20:00:00",
      :place => "Skabetka"
    )
    assert @match.save
     
    @game = Game.new(
      :match_id => @match.id,
      :game_number => 1,
      :game_type => GAME_TYPE_FOURS,
      :score_home => 0,
      :score_away => 0
    )
    assert @game.save
    
    assert_equal 1, Game.by_season(2099).count
  end
   
  test "scope by season advanced" do
    for a in 2010..2014
      @matches = Match.where(:season => a)
       
      @sum = 0
      for match in @matches
        @sum += match.games.count
      end
      
      @games = Game.by_season(a)
      
      assert_equal @sum, @games.count
      
      for game in @games
        assert_equal a, game.match.season
      end
    end
  end
end
