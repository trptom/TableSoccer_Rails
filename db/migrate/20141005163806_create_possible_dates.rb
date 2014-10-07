class CreatePossibleDates < ActiveRecord::Migration
  def change
    create_table :possible_dates do |t|
      t.datetime :start_time,   :null => false
      t.datetime :end_time,     :null => false
      t.references :match,      :null => false

      t.timestamps
    end
    add_index :possible_dates, :match_id
  end
end
