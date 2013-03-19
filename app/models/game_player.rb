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

  validates :game_id,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :message => "chybná hra" },
  :if => :game_id

  validates :player_id,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :message => "chybný hráč" },
  :if => :player_id

#  validates :game,
#  :if => :game

#  validates :player,
#  :if => :player
end
