require 'test_helper'

class LeagueTest < ActiveSupport::TestCase
  test "teams function" do
    for league in League.all
      @teams = league.teams(2014) # just for season 2014 - anz other isnt contained in fixtures
      @lt_list = league.league_teams.where(:season => 2014)
      
      for lt in @lt_list do
        assert @teams.include?(lt.team), "every team should be contained in array"
      end
      
      assert_equal @lt_list.count, @teams.count, "array size shoud match league_teams count"
    end
  end
end
