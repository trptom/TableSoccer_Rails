class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :match,    :null => false
      t.integer :game_number, :null => false
      t.integer :game_type,   :null => false
      t.integer :score_home,  :null => true,  :default => nil
      t.integer :score_away,  :null => true,  :default => nil

      t.timestamps
    end
    add_index :games, :match_id
  end
end
