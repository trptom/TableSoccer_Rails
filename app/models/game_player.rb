# coding:utf-8

class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  attr_accessible :position, :team, :game, :player, :game_id, :player_id

  validates :position,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :message => "neplatná pozice" },
    :allow_nil => true,
  :if => :position

  validates :team,
    :numericality => { :only_integer => true, :message => "neplatný tým" },
    :allow_nil => true,
  :if => :team

  validates :game_id, :presence => { :message => "chybná hra" }
  validates :game, :associated => { :message => "chybná hra" }

  validates :player_id, :presence => { :message => "chybný hráč" }
  validates :player, :associated => { :message => "chybný hráč" }

#  validates :game,
#  :if => :game

#  validates :player,
#  :if => :player

  
  scope :by_season, ->(season) {
      select("game_players.*")
        .from("game_players, games, matches")
        .where("matches.season = ?", season)
        .where("game_players.game_id = games.id")
        .where("games.match_id = matches.id")
  }
end
