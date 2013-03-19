# coding:utf-8

class Team < ActiveRecord::Base
  has_many :matches_home,
    :foreign_key => 'team_home_id', :class_name => 'Match'
  has_many :matches_away,
    :foreign_key => 'team_away_id', :class_name => 'Match'
  has_many :league_teams
  has_many :players

  attr_accessible :name, :short_name, :shortcut, :logo, :matches_home, :matches_away, :league_teams, :players

  validates :name,
    :length => { :minimum => 3, :maximum => 255, :message => "špatná délka názvu (3-255)" },
    :uniqueness => { :case_sensitive => false, :message => "liga s daným názvem již existuje" },
  :if => :name

  validates :short_name,
    :length => { :minimum => 3, :maximum => 50, :message => "špatná délka zkratky (3-50)" },
  :if => :short_name

  validates :shortcut,
    :length => { :minimum => 2, :maximum => 4, :message => "špatná délka zkratky (2-4)" },
  :if => :shortcut

  validates :logo,
    :length => { :minimum => 1, :maximum => 255, :message => "špatná délka cesty k logu (1-255)" },
    :allow_nil => true,
    :allow_blank => true,
  :if => :logo
end
