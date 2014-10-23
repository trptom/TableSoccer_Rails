# coding:utf-8

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
  
  test "scope home and away game players" do
    for game in Game.all
      @home = game.home_game_players
      @away = game.away_game_players
      
      for hgp in @home
        assert_equal TEAM_HOME, hgp.team, "team of home_game_players should be TEAM_HOME"
      end
      for agp in @away
        assert_equal TEAM_AWAY, agp.team, "team of away_game_players should be TEAM_AWAY"
      end
      
      assert_equal game.game_players.count, (@home.count + @away.count), "sum of home and away players should match game.game_players.count"
    end
  end
  
  test "started function" do
    # just simply test it from fixtures
    assert games(:round_1_game_1).started
    assert games(:round_1_game_2).started
    assert !games(:round_3_game_1).started
    assert !games(:round_3_game_2).started
  end
  
  test "score_str function" do
    # just simply test it from fixtures
    assert_equal "2:0", games(:round_1_game_1).score_str
    assert_equal "2:1", games(:round_1_game_2).score_str
    assert_equal "-:-", games(:round_3_game_1).score_str
    assert_equal "-:-", games(:round_3_game_2).score_str
  end
  
  test "type_str functyion" do
    for game in Game.all
      assert_not_nil game.type_str, "type_str should never be nil"
      assert_not_equal "", game.type_str, "type_str should never be empty string"
    end
  end
  
  test "players_str function" do
    # home players test
    assert_equal "Pól, Freedy", games(:round_1_game_1).home_players_str
    assert_equal "Pól; Freedy", games(:round_1_game_1).home_players_str("; ")
    assert_equal "Pól; Freedy", games(:round_1_game_1).home_players_str("; ", "XXX")
    
    # away players test (there should be no players)
    assert_not_equal "", games(:round_1_game_1).away_players_str, "no players string should not be empty"
    assert_not_equal "", games(:round_1_game_1).away_players_str(", "), "no players string should not be empty"
    assert_equal "XXX", games(:round_1_game_1).away_players_str(", ", "XXX"), "no players string should be XXX"
  end
end
