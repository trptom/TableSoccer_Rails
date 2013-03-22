class DefaultAccount < ActiveRecord::Migration
  def self.up
    # pridani admina pri migraci
    User.create :username => "admin", :email => "", :password => "root", :password_confirmation => "root"
  end

  def self.down
  end
end