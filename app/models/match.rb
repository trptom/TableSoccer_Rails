# coding:utf-8

class Match < ActiveRecord::Base
  belongs_to :league
  belongs_to :team_home,
    :class_name => 'Team', :foreign_key => 'team_home_id'
  belongs_to :team_away,
    :class_name => 'Team', :foreign_key => 'team_away_id'

  has_many :games, :dependent => :destroy
  has_many :possible_dates, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  attr_accessible :place, :season, :start_date, :team_away, :team_home, :team_away_id, :team_home_id, :score_home, :score_away, :league_id

  validates :place,
    :length => { :minimum => 3, :maximum => 255, :message => "špatná délka názvu místa (3-255)" },
    :allow_nil => true,
    :allow_blank => true,
  :if => :place

  validates :season,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 2000, :less_than_or_equal_to  => 2100, :message => "špatná sezona" },
  :if => :season

  validates :score_home,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to  => 10, :message => "neplatné skóre domácích" },
    :allow_nil => true,
  :if => :score_home

  validates :score_away,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to  => 10, :message => "neplatné skóre hostů" },
    :allow_nil => true,
  :if => :score_away

  validates :team_home_id, :presence => { :message => "špatný tým domácích" }
  validates :team_home, :associated => { :message => "špatný tým domácích" }

  validates :team_away_id, :presence => { :message => "špatný tým hostí" }
  validates :team_away, :associated => { :message => "špatný tým hostí" }

  validates :league_id, :presence => { :message => "špatná liga" }
  validates :league, :associated => { :message => "špatná liga" }
  
#  validates :start_date,
#    :allow_blank => false,
#    :allow_nil => false,
#  :if => :start_date

  scope :by_team_id, ->(team_id) {
    where("(team_home_id = ?) OR (team_away_id = ?)", team_id, team_id);
  }
  
  scope :by_team, ->(team) {
    where("(team_home_id = ?) OR (team_away_id = ?)", team.id, team.id);
  }
  
  scope :by_player, ->(player) {
    where("(team_home_id = ?) OR (team_away_id = ?)", player.team.id, player.team.id);
  }
  
  scope :past, ->(to_date = DateTime.now) {
    where("start_date < ?", to_date)
  }
  
  scope :future, ->(to_date = DateTime.now) {
    where("start_date >= ?", to_date)
  }
  
  def get_players_attendance(team)
    @att_players = Player.by_match_attendance(self.id)
    @ret = {
      :yes => [],
      :no => []
    }
    
    for player in team.players
      if @att_players.where(:id => player.id).all.count > 0
        @ret[:yes] << player
      else
        @ret[:no] << player
      end
    end
    
    return @ret
  end
  
  def get_players_attendance_str(team)
    @ret_src = get_players_attendance(team)
    @ret_dest = {
      :yes => [],
      :no => []
    }
    
    for item_yes in @ret_src[:yes]
      @ret_dest[:yes] << item_yes.nick_or_name
    end
    
    for item_no in @ret_src[:no]
      @ret_dest[:no] << item_no.nick_or_name
    end
    
    return {
      :yes_array => @ret_src[:yes],
      :yes => @ret_dest[:yes].join(", "),
      :no_array => @ret_src[:no],
      :no => @ret_dest[:no].join(", ")
    }
  end
  
  def started
    return !(score_home == nil || score_away == nil || (score_home == 0 && score_away == 0))
  end
  
  def title
    str = "#{team_home.name} vs. #{team_away.name}"
    if started
      return "#{str} (#{result})"
    else
      return str
    end
  end
  
  def can_fill_attendance
    return !started && start_date > DateTime.now
  end
  
  # Returns score string. When some of scores not set (is nil) or both scores
  # are 0, returns "-:-".
  def result
    if started
      return "#{score_home}:#{score_away}"
    else
      return "-:-"
    end
  end
  
  # Returns TEAM_HOME or TEAM_AWAY constants, depending onb whether param is
  # home or away team. When team is not in match, returns nil.
  def team_type(team)
    if (team == team_home)
      return TEAM_HOME
    end
    if (team == team_away)
      return TEAM_AWAY
    end
    return nil
  end
end
