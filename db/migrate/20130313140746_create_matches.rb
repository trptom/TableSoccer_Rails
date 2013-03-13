class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.column "team_home_id", :integer,  :null => false
      t.column "team_away_id", :integer,  :null => false
      t.references :league,               :null => false
      t.integer :season,                  :null => false
      t.datetime :start_date,             :null => false
      t.string :place,                    :null => true,    :default => nil

      t.timestamps
    end
    add_index :matches, :team_home_id
    add_index :matches, :team_away_id
    add_index :matches, :league_id
  end
end
