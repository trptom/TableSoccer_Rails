# coding:utf-8

class Team < ActiveRecord::Base
  has_many :matches_home,
    :foreign_key => 'team_home_id', :class_name => 'Match'
  has_many :matches_away,
    :foreign_key => 'team_away_id', :class_name => 'Match'
  has_many :league_teams
  has_many :players

  attr_accessible :name, :short_name, :shortcut, :logo, :logo_cache, :matches_home, :matches_away, :league_teams, :players

  mount_uploader :logo, TeamLogoUploader
  
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


  def logo_image(type = :large)
    url = logo_url(type)
    if url != nil && url != ""
      return ActionController::Base.helpers.image_tag(url)
    else
      if DEFAULT_IMAGES[:team_logo][type]
        return ActionController::Base.helpers.image_tag(ActionController::Base.helpers.asset_path(DEFAULT_IMAGES[:team_logo][type]))
      else
        return nil
      end
    end
  end
end
