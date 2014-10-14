# coding:utf-8

class Player < ActiveRecord::Base
  belongs_to :team

  has_many :game_players
  has_many :users
  has_many :possible_date_selections

  attr_accessible :first_name, :second_name, :nick, :team, :team_id, :game_players

  validates :first_name,
    :length => { :minimum => 2, :maximum => 50, :message => "chybný formát jména (2-50 znaků)" },
    :allow_blank => true,
  :if => :first_name

  validates :second_name,
    :length => { :minimum => 2, :maximum => 50, :message => "chybný formát příjmení (2-50 znaků)" },
    :allow_blank => true,
  :if => :second_name

  validates :nick,
    :length => { :minimum => 2, :maximum => 50, :message => "špatná délka zkratky (2-50)" },
  :if => :nick

#  validates :team_id, :presence => { :message => "chybný tým" }
  validates :team, :associated => { :message => "chybný tým" }

  ##############################################################################
  
  def nick_or_name
    if (nick != nil && nick != "")
      return nick
    end
    
    if (first_name == nil || first_name == "")
      return second_name
    end
    
    if (second_name == nil || second_name == "")
      return first_name
    end
    
    return "#{first_name} #{second_name}"
  end
end
