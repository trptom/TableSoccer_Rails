# coding:utf-8

class Player < ActiveRecord::Base
  belongs_to :team

  has_many :game_players
  has_many :users

  attr_accessible :first_name, :second_name, :nick, :team, :team_id, :game_players

  validates :first_name,
    :format => { :with => /^(|[a-zA-Z\-]{2,})$/, :message => "chybný formát jména (alespoň 2 znaky)" },
    :allow_blank => true,
  :if => :first_name

  validates :second_name,
    :format => { :with => /^(|[a-zA-Z\-]{2,})$/, :message => "chybný formát příjmení (alespoň 2 znaky)" },
    :allow_blank => true,
  :if => :second_name

  validates :nick,
    :length => { :minimum => 2, :maximum => 50, :message => "špatná délka zkratky (2-50)" },
  :if => :nick

  ##############################################################################
end
