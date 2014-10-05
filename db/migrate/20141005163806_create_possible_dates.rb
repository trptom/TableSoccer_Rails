class CreatePossibleDates < ActiveRecord::Migration
  def change
    create_table :possible_dates do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :match

      t.timestamps
    end
    add_index :possible_dates, :match_id
  end
end
