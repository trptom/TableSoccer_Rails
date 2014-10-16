class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user,       :null => false
      t.references :match,      :null => true, :default => nil
      t.references :game,       :null => true, :default => nil
      t.references :comment,    :null => true, :default => nil
      t.string :title,          :null => true, :default => nil
      t.text :content,          :null => false
      t.boolean :visible,       :null => false, :default => true

      t.timestamps
    end
    
    add_index :comments, :user_id
    add_index :comments, :match_id
    add_index :comments, :game_id
    add_index :comments, :comment_id
  end
end
