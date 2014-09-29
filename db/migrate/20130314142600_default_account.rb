class DefaultAccount < ActiveRecord::Migration
  def self.up
    # pridani admina pri migraci
    @user = User.new(
      :username => ROOT_ACCOUNT_USERNAME,
      :email => ROOT_ACCOUNT_EMAIL,
      :password => ROOT_ACCOUNT_PASSWORD,
      :password_confirmation => ROOT_ACCOUNT_PASSWORD)
    @user.save
    @user.activate!
  end

  def self.down
    User.delete_all
  end
end