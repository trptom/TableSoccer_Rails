# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130314093434) do

  create_table "game_players", :force => true do |t|
    t.integer  "game_id",    :null => false
    t.integer  "player_id",  :null => false
    t.integer  "team",       :null => false
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "game_players", ["game_id"], :name => "index_game_players_on_game_id"
  add_index "game_players", ["player_id"], :name => "index_game_players_on_player_id"

  create_table "games", :force => true do |t|
    t.integer  "match_id",    :null => false
    t.integer  "game_number", :null => false
    t.integer  "game_type",   :null => false
    t.integer  "score_home"
    t.integer  "score_away"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "games", ["match_id"], :name => "index_games_on_match_id"

  create_table "league_teams", :force => true do |t|
    t.integer  "league_id",  :null => false
    t.integer  "team_id",    :null => false
    t.integer  "season",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "league_teams", ["league_id"], :name => "index_league_teams_on_league_id"
  add_index "league_teams", ["team_id"], :name => "index_league_teams_on_team_id"

  create_table "leagues", :force => true do |t|
    t.string   "name",                      :null => false
    t.string   "short_name",                :null => false
    t.string   "shortcut",                  :null => false
    t.integer  "level",      :default => 1, :null => false
    t.integer  "division",   :default => 1, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "matches", :force => true do |t|
    t.integer  "team_home_id", :null => false
    t.integer  "team_away_id", :null => false
    t.integer  "league_id",    :null => false
    t.integer  "season",       :null => false
    t.datetime "start_date",   :null => false
    t.string   "place"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "score_home"
    t.integer  "score_away"
  end

  add_index "matches", ["league_id"], :name => "index_matches_on_league_id"
  add_index "matches", ["team_away_id"], :name => "index_matches_on_team_away_id"
  add_index "matches", ["team_home_id"], :name => "index_matches_on_team_home_id"

  create_table "players", :force => true do |t|
    t.string   "first_name"
    t.string   "second_name"
    t.string   "nick",        :null => false
    t.integer  "team_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "players", ["team_id"], :name => "index_players_on_team_id"

  create_table "teams", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "short_name", :null => false
    t.string   "shortcut",   :null => false
    t.string   "logo"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",                                           :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.integer  "player_id"
    t.boolean  "blocked",                         :default => false, :null => false
    t.boolean  "is_admin",                        :default => false, :null => false
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "users", ["player_id"], :name => "index_users_on_player_id"

end
