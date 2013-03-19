# coding:utf-8

class Match < ActiveRecord::Base
  belongs_to :league
  belongs_to :team_home,
    :class_name => 'Team', :foreign_key => 'team_home_id'
  belongs_to :team_away,
    :class_name => 'Team', :foreign_key => 'team_away_id'

  has_many :games

  attr_accessible :place, :season, :start_date, :team_away, :team_home, :team_away_id, :team_home_id, :score_home, :score_away, :league_id

  validates :place,
    :length => { :minimum => 3, :maximum => 255, :message => "špatná délka názvu místa (3-255)" },
    :allow_nil => true,
  :if => :place

  validates :season,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 2000, :less_than_or_equal_to  => 2100, :message => "špatná sezona" },
  :if => :season

  validates :score_home,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than  => 2, :message => "neplatné skóre domácích" },
    :allow_nil => true,
  :if => :score_home

  validates :score_away,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than  => 2, :message => "neplatné skóre hostů" },
    :allow_nil => true,
  :if => :score_away

  validates :team_home_id, :presence => { :message => "špatný tým domácích" }
  validates :team_home, :associated => { :message => "špatný tým domácích" }

  validates :team_away_id, :presence => { :message => "špatný tým hostí" }
  validates :team_away, :associated => { :message => "špatný tým hostí" }
  
#  validates :start_date,
#    :allow_blank => false,
#    :allow_nil => false,
#  :if => :start_date
end
