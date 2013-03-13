# coding:utf-8

class LeagueTeam < ActiveRecord::Base
  belongs_to :league
  belongs_to :team

  attr_accessible :season, :team, :league

  validates :season,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 2000, :less_than_or_equal_to  => 2100, :message => "špatná sezona" },
  :if => :season

#  validates :team,
#  :if => :team

#  validates :league,
#  :if => :league
end
