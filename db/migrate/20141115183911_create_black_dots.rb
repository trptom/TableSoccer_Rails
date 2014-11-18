class CreateBlackDots < ActiveRecord::Migration
  def self.up
    create_table :black_dots do |t|
      t.references :player, :null => false
      t.integer :count,     :null => false, :default => 1
      t.integer :reason,    :null => true,  :default => nil
      t.text :description,  :null => true,  :default => nil
      t.boolean :viewed,    :null => false, :default => false

      t.timestamps
    end
    add_index :black_dots, :player_id
    add_index :black_dots, :reason
    add_index :black_dots, :viewed
    
    # add also counter for paid beers
    add_column :players, :dots_total, :integer, :null => false, :default => 0
    add_column :players, :beer_paid, :integer, :null => false, :default => 0
  end
  
  def self.down
    drop_table :black_dots
    
    remove_column :players, :dots_total
    remove_column :players, :beer_paid
  end
end
