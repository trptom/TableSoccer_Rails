class DefaultAccount < ActiveRecord::Migration
  def self.up
    # pridani admina pri migraci
    @user = User.new(
      :username => "admin",
      :email => "",
      :password => "root",
      :password_confirmation => "root")
    @user.save
  end

  def self.down
    User.where(:username => "admin").destroy
  end
end