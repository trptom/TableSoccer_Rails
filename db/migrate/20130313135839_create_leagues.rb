class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name,         :null => false
      t.string :short_name,   :null => false
      t.string :shortcut,     :null => false
      t.integer :level,       :null => false, :default => 1
      t.integer :division,    :null => false, :default => 1

      t.timestamps
    end
  end
end
