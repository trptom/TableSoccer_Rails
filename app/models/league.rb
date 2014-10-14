# coding:utf-8

class League < ActiveRecord::Base
  has_many :league_teams, :dependent => :destroy
  has_many :matches, :dependent => :destroy

  attr_accessible :name, :short_name, :shortcut, :level, :division, :league_teams, :matches

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

  validates :level,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to  => 100, :message => "level není celé číslo v rozmezí 1-100" },
  :if => :level

  validates :division,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to  => 100, :message => "divize není celé číslo v rozmezí 1-100" },
  :if => :division
  
  def teams(season)
    arr = self.league_teams
    ret = []
    
    if (season != nil)
      arr = arr.where(:season => season)
    end
    
    for item in arr.all
      ret << item.team
    end
    
    return ret
  end
end
