module LeaguesHelper
  
  def draw(league, season, team = nil)
    teams = league.teams(season)
    date = Date.new(season, 1, 1);
    ret = true;
    
    if (team != nil)
      for team2 in teams
        if team != team2
          m1 = Match.new(
            :place => nil,
            :season => season,
            :start_date => date,
            :team_away_id => team2.id,
            :team_home_id => team.id,
            :score_home => 0,
            :score_away => 0,
            :league_id => league.id
          );
          
          m2 = Match.new(
            :place => nil,
            :season => season,
            :start_date => date,
            :team_away_id => team.id,
            :team_home_id => team2.id,
            :score_home => 0,
            :score_away => 0,
            :league_id => league.id
          );
          
          ret = m1.save && ret;
          ret = m2.save && ret;
        end
      end
    else
      for team3 in teams
        for team4 in teams
          if team3 != team4
            m3 = Match.new(
              :place => nil,
              :season => season,
              :start_date => date,
              :team_away_id => team4.id,
              :team_home_id => team3.id,
              :score_home => 0,
              :score_away => 0,
              :league_id => league.id
            );

            ret = m3.save && ret;
          end
        end
      end
    end
    
    return ret;
  end
  
end
