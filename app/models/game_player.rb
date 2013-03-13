# coding:utf-8

class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  attr_accessible :position, :team, :game, :player

  validates :position,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :message => "neplatná pozice" },
    :allow_nil => true,
  :if => :position

  validates :team,
    :numericality => { :only_integer => true, :message => "neplatný tým" },
    :allow_nil => true,
  :if => :team

#  validates :game,
#  :if => :game

#  validates :player,
#  :if => :player
end
