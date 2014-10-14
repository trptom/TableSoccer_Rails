# coding:utf-8

class Game < ActiveRecord::Base
  belongs_to :match

  has_many :game_players, :dependent => :destroy

  attr_accessible :game_number, :game_type, :score_home, :score_away, :game_players, :match, :match_id

  validates :game_number,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to  => 11, :message => "neplatné pořadové číslo hry" },
  :if => :game_number

  validates :game_type,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than  => GAME_TYPE_STR.length, :message => "neplatný typ hry" },
  :if => :game_type

  validates :score_home,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to  => 2, :message => "neplatné skóre domácích" },
    :allow_nil => true,
  :if => :score_home

  validates :score_away,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to  => 2, :message => "neplatné skóre hostů" },
    :allow_nil => true,
  :if => :score_away

  validates :match_id, :presence => { :message => "chybný zápas" }
  validates :match, :associated => { :message => "chybný zápas" }
  
  scope :by_season, ->(season) {
    select("games.*, matches.season")
        .joins("LEFT OUTER JOIN matches ON matches.id = games.match_id")
        .where("matches.season = ?", season)
  }
end
