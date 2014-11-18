# coding:utf-8

class Player < ActiveRecord::Base
  belongs_to :team

  has_many :game_players, :dependent => :destroy
  has_many :users
  has_many :possible_date_selections, :dependent => :destroy
  has_many :black_dots, :dependent => :destroy

  attr_accessible :first_name, :second_name, :nick, :team, :team_id, :game_players, :beer_paid, :dots_total

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

  scope :by_match_attendance, ->(match_id) {
    select("players.*")
        .from("players, possible_date_selections, possible_dates")
        .where("(possible_dates.match_id = ?)", match_id)
        .where("(possible_date_selections.possible_date_id = possible_dates.id)")
        .where("(possible_date_selections.player_id = players.id)")
        .group("players.id")
  }
  
  ##############################################################################
  
  def nick_or_name
    if (nick == nil && first_name == nil && second_name == nil)
      return nil
    end
    
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
  
  def dots_grouped
    return (dots_total / BLACK_DOTS_GROUPING).floor
  end
  
  def dots_over_group
    return dots_total % BLACK_DOTS_GROUPING
  end
  
  def dots
    return black_dots
  end
end
