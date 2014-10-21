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

ActiveRecord::Schema.define(:version => 20141021142000) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "provider",   :null => false
    t.string   "uid",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id",                      :null => false
    t.integer  "match_id"
    t.integer  "game_id"
    t.integer  "comment_id"
    t.string   "title"
    t.text     "content",                      :null => false
    t.boolean  "visible",    :default => true, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "comments", ["comment_id"], :name => "index_comments_on_comment_id"
  add_index "comments", ["game_id"], :name => "index_comments_on_game_id"
  add_index "comments", ["match_id"], :name => "index_comments_on_match_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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
    t.datetime "start_date"
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
    t.string   "nick"
    t.integer  "team_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "players", ["team_id"], :name => "index_players_on_team_id"

  create_table "possible_date_selections", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "priority"
    t.integer  "possible_date_id"
    t.integer  "player_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "possible_date_selections", ["player_id"], :name => "index_possible_date_selections_on_player_id"
  add_index "possible_date_selections", ["possible_date_id"], :name => "index_possible_date_selections_on_possible_date_id"

  create_table "possible_dates", :force => true do |t|
    t.datetime "start_time", :null => false
    t.datetime "end_time",   :null => false
    t.integer  "match_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "possible_dates", ["match_id"], :name => "index_possible_dates_on_match_id"

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
    t.string   "name"
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
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address"
  end

  add_index "users", ["last_logout_at", "last_activity_at"], :name => "index_users_on_last_logout_at_and_last_activity_at"
  add_index "users", ["player_id"], :name => "index_users_on_player_id"

end
