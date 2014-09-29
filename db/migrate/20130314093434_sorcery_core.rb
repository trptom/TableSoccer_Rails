class SorceryCore < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username,         :null => false  # if you use another field as a username, for example email, you can safely remove this field.
      t.string :email,            :default => nil # if you use this field as a username, you might want to make it :null => false.
      t.string :crypted_password, :default => nil
      t.string :salt,             :default => nil
      t.references :player,       :null => true,  :default => nil
      
      t.boolean :blocked,           :null => false, :default => false
      t.boolean :is_admin,        :null => false, :default => false
      
      t.string :activation_state
      t.string :activation_token
      t.datetime :activation_token_expires_at
      t.string :reset_password_token,              :null => true, :default => nil
      t.datetime :reset_password_token_expires_at, :null => true, :default => nil
      t.datetime :reset_password_email_sent_at,    :null => true, :default => nil

      t.timestamps
    end
    add_index :users, :player_id
  end

  def self.down
    drop_table :users
  end
end