class AddMatchScore < ActiveRecord::Migration
  def self.up
    change_table :matches do |t|
      t.integer :score_home,  :null => true, :default => nil
      t.integer :score_away,  :null => true, :default => nil
    end
  end

  def self.down
    
  end
end