# coding:utf-8

class LeagueTeam < ActiveRecord::Base
  belongs_to :league
  belongs_to :team

  attr_accessible :season, :team, :league, :league_id, :team_id

  validates :season,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 2000, :less_than_or_equal_to  => 2100, :message => "špatná sezona" },
  :if => :season

  validates :league_id,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :message => "chybná liga" },
  :if => :league_id

  validates :team_id,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :message => "chybný tým" },
  :if => :team_id
end
