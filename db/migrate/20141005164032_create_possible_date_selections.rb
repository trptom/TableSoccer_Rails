class CreatePossibleDateSelections < ActiveRecord::Migration
  def change
    create_table :possible_date_selections do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :priority
      t.references :possible_date
      t.references :player

      t.timestamps
    end
    add_index :possible_date_selections, :possible_date_id
    add_index :possible_date_selections, :player_id
  end
end
