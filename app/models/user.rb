# coding:utf-8

class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  belongs_to :player

  #attr_accessor :password, :password_confirmation
  
  attr_accessible :username, :email, :name,
    :password, :password_confirmation, :crypted_password, :salt,
    :player, :player_id,
    :activation_expires_at, :activation_state, :activation_token, :authentications_attributes,
    :blocked, :is_admin,
    :reset_password_token, :reset_password_token_expires_at, :reset_password_email_sent_at,
    :last_login_at, :last_logout_at, :last_activity_at


  validates :username,
    :length => { :minimum => 3, :maximum => 255, :message => "špatná délka uživatelského jména (3-255)" },
    :uniqueness => { :case_sensitive => false, :message => "uživatel s daným jménem již existuje" }

  validates :email,
    :format => { :with => /^.+@.+\..+$/, :message => "chybný formát emailu" },
    :allow_blank => true,
    :allow_nil => true

  validates :player_id, :presence => { :message => "chybný propojený hráč" }, :allow_blank => true, :allow_nil => true, :if => :player_id
  validates :player, :associated => { :message => "chybný propojený hráč" }, :allow_blank => true, :allow_nil => true

  validates_length_of :password, :minimum => 3, :message => "heslo musí mít alespoň 3 znaky", :if => :password
  validates_confirmation_of :password, :message => "heslo a jeho kontrola se liší", :if => :password
  

  ##############################################################################
  # instance functions
  ##############################################################################
  
  def get_name
    return (name == nil || name == "") ? username : name;
  end
  
  def has_team(team)
    if team.kind_of?(Team)
      return player != nil && player.team.id == team.id
    end
    if team.kind_of?(Integer)
      return player != nil && player.team.id == team
    end
    
    return false
  end
  
  ##############################################################################
  # static functions
  ##############################################################################
  
  def self.get_first_free_name(origin)
    name = origin
    id = 1
    while User.where(:username => name).all.count > 0
      logger.info "name " + name + " already in use"
      name = origin + (++id).to_s
      logger.info "changing name to " + name
    end
    
    logger.info "used name: " + name
    return name
  end
end
