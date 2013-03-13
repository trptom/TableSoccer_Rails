class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first_name,   :null => true,  :default => nil
      t.string :second_name,  :null => true,  :default => nil
      t.string :nick,         :null => false
      t.references :team,     :null => true,  :default => nil

      t.timestamps
    end
    add_index :players, :team_id
  end
end
