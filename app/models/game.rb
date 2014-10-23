# coding:utf-8

class Game < ActiveRecord::Base
  belongs_to :match

  has_many :game_players, :dependent => :destroy
  has_many :comments, :dependent => :destroy

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
  
  def home_game_players
    return game_players.home
  end
  
  def away_game_players
    return game_players.away
  end
  
  def players_str(game_players, separator = ", ", no_player_string = I18n.t("messages.base.no_player_presented"))
    if game_players.count == 0
      return no_player_string
    end
    
    ret = ""
    for player in game_players
      ret += player.player.nick_or_name
      if (player != game_players.last)
        ret += separator
      end
    end
    return ret    
  end
  
  def home_players_str(separator = ", ", no_player_string = I18n.t("messages.base.no_player_presented"))
    return players_str(home_game_players, separator, no_player_string)
  end
  
  def away_players_str(separator = ", ", no_player_string = I18n.t("messages.base.no_player_presented"))
    return players_str(away_game_players, separator, no_player_string)
  end
  
  def started
    return !(score_home == nil || score_away == nil || (score_home == 0 && score_away == 0))
  end
  
  def score_str
    if (started)
      return "#{score_home}:#{score_away}"
    else
      return "-:-"
    end
  end
  
  def type_str
    return I18n.t GAME_TYPE_STR[game_type]
  end
end
