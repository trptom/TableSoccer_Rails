class AddMatchScore < ActiveRecord::Migration
  def change
    change_table :matches do |t|
      t.integer :score_home,  :null => true, :default => nil
      t.integer :score_away,  :null => true, :default => nil
    end
  end
end