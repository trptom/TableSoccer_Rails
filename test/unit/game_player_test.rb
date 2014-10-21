require 'test_helper'

class GamePlayerTest < ActiveSupport::TestCase
  test "scopes by_season home away" do
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
      :game_type => GAME_TYPE_DOUBLE
    )
    assert @game.save
    
    @game_player1 = GamePlayer.new(
      :game => @game,
      :player => players(:trptom),
      :team => TEAM_HOME
    )
    @game_player2 = GamePlayer.new(
      :game => @game,
      :player => players(:trptom),
      :team => TEAM_HOME
    )
    @game_player3 = GamePlayer.new(
      :game => @game,
      :player => players(:pol),
      :team => TEAM_AWAY
    )
    
    assert @game_player1.save
    assert @game_player2.save
    assert @game_player3.save
    
    assert_equal 3, GamePlayer.by_season(2099).count
    assert_equal 0, GamePlayer.by_season(2098).count
    assert_equal 3, @game.game_players.by_season(2099).count
    assert_equal 0, @game.game_players.by_season(2098).count
    
    assert_equal 2, GamePlayer.by_season(2099).where(:team => TEAM_HOME).count
    assert_equal 1, GamePlayer.by_season(2099).where(:team => TEAM_AWAY).count
    assert_equal 2, GamePlayer.by_season(2099).home.count
    assert_equal 1, GamePlayer.by_season(2099).away.count
    
    for gphome in GamePlayer.by_season(2099).home
      assert_equal TEAM_HOME, gphome.team, "gphome.team should be TEAM_HOME"
    end
    
    for gpaway in GamePlayer.by_season(2099).away
      assert_equal TEAM_AWAY, gpaway.team, "gpaway.team should be TEAM_AWAY"
    end
  end
end
