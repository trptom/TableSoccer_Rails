require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  test "result function" do
    assert_equal "7:3", matches(:round_1).result
    assert_equal "-:-", matches(:round_10).result
  end
  
  test "can_fill_attendance function" do
    @match_past = Match.new(
      :season => 2000,
      :team_home_id => 2,
      :team_away_id => 1,
      :league_id => 3,
      :start_date => "2000-06-13 20:00:00",
      :place => "Woodoo"
    )
    assert @match_past.save
    
    @date = DateTime.now + 100
    @match_future = Match.new(
      :season => 2000,
      :team_home_id => 2,
      :team_away_id => 1,
      :league_id => 3,
      :start_date => @date,
      :place => "Woodoo"
    )
    assert @match_future.save
    
    @possible_date_past = PossibleDate.new(
      :start_time => (@match_past.start_date),
      :end_time => (@match_past.start_date),
      :match => @match_past
    )
    assert @possible_date_past.save
    
    @possible_date_future = PossibleDate.new(
      :start_time => (@match_future.start_date),
      :end_time => (@match_future.start_date),
      :match => @match_future
    )
    assert @possible_date_future.save
    
    assert !@match_past.can_fill_attendance, "shouldnt allow fill attendance in past matches (without possible dates)"
    
    @match_past.possible_dates << @possible_date_past
    assert @match_past.save
    assert !@match_past.can_fill_attendance, "shouldnt allow fill attendance in past matches"
    
    assert @match_future.can_fill_attendance, "should allow fill attendance in future matches (without possible dates)"
    
    @match_future.possible_dates << @possible_date_future
    assert @match_future.save
    assert @match_future.can_fill_attendance, "should allow fill attendance in future matches"
    
    @match_future.score_home = 5
    @match_future.score_away = 5
    assert @match_future.save
    assert !@match_future.can_fill_attendance, "shouldnt allow fill attendance in future matches (with set score)"
  end
  
  test "title function" do
    assert_equal "Mortal vs. Inarabu (7:3)", matches(:round_1).title
    assert_equal "K2 \"A\" vs. Mortal (6:5)", matches(:round_2).title
    assert_equal "Mortal vs. K2 \"B\"", matches(:round_3).title
  end
  
  test "scope by_team and by_team_id" do
    assert_equal Match.all.count, Match.by_team(teams(:mortal)).count, "mortal should be contained in all matches"
    assert_equal Match.all.count, Match.by_team_id(teams(:mortal).id).count, "mortal should be contained in all matches"
    
    @k2a_matches = Match.by_team(teams(:k2a))
    @k2a_matches_id = Match.by_team_id(teams(:k2a).id)
    
    assert_equal 2, @k2a_matches.count, "K2 A should be contained in 2 matches (home and away in mortal)"
    assert_equal 2, @k2a_matches_id.count, "K2 A should be contained in 2 matches (home and away in mortal)"
    
    for match in @k2a_matches do
      assert match.team_home == teams(:k2a) || match.team_away == teams(:k2a), "K2 A should be home or away team"
    end
    
    for match_id in @k2a_matches_id do
      assert match_id.team_home == teams(:k2a) || match_id.team_away == teams(:k2a), "K2 A should be home or away team"
    end
  end
  
  test "scope by_player" do
    assert_equal 10, Match.by_player(players(:trptom)).count, "trptom is in mortal which played all 10 games"
  end
end
