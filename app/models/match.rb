# coding:utf-8

class Match < ActiveRecord::Base
  belongs_to :league
  belongs_to :team_home,
    :class_name => 'Team', :foreign_key => 'team_home_id'
  belongs_to :team_away,
    :class_name => 'Team', :foreign_key => ':team_away_id'

  has_many :games

  attr_accessible :place, :season, :start_date, :team_away, :team_home

  validates :place,
    :length => { :minimum => 3, :maximum => 255, :message => "špatná délka názvu místa (3-255)" },
    :allow_nil => true,
  :if => :place

  validates :season,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 2000, :less_than_or_equal_to  => 2100, :message => "špatná sezona" },
  :if => :season

#  validates :start_date,
#    :allow_blank => false,
#    :allow_nil => false,
#  :if => :start_date

#  validates :team_away,
#  :if => :team_away

#  validates :team_home,
#  :if => :team_home
end
