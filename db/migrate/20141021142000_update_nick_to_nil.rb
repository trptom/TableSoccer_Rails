class UpdateNickToNil < ActiveRecord::Migration
  def self.up
    change_column :players, :nick, :string, :null => true, :default => nil
  end

  def self.down
    change_column :players, :nick, :string, :null => false
  end
end