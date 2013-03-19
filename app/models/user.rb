# coding:utf-8

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  belongs_to :player

  attr_accessible :username, :email, :password, :password_confirmation, :player, :player_id

  validates :username,
    :length => { :minimum => 3, :maximum => 255, :message => "špatná délka uživatelského jména (3-255)" },
    :uniqueness => { :case_sensitive => false, :message => "uživatel s daným jménem již existuje" },
  :if => :username

  validates :email,
    :format => { :with => /^.+@.+\..+$/, :message => "chybný formát emailu" },
    :allow_blank => true,
    :allow_nil => true,
  :if => :email

  validates :player_id, :presence => { :message => "chybný propojený hráč" }
  validates :player, :associated => { :message => "chybný propojený hráč" }

  validates_length_of :password, :minimum => 3, :message => "heslo musí mít alespoň 3 znaky", :if => :password
  validates_confirmation_of :password, :message => "heslo a jeho kontrola se liší", :if => :password
end
