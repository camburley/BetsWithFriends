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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170926002153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "provider"
    t.string "fb_id"
    t.string "fb_token"
    t.string "profile_picture"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bets", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.string "wage"
    t.json "user_picked", default: []
    t.json "opponent_picked", default: []
    t.integer "opponent"
    t.datetime "expiration_date"
    t.boolean "closed", default: false
    t.boolean "notifications", default: false
    t.boolean "resolved", default: false
    t.integer "winner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepted"
    t.string "day"
    t.integer "week"
    t.string "user_score"
    t.string "opponent_score"
    t.datetime "game_time"
    t.index ["game_id"], name: "index_bets_on_game_id"
    t.index ["user_id"], name: "index_bets_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "game_type"
    t.string "title"
    t.string "description"
    t.string "image"
    t.datetime "start_date"
    t.datetime "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "validation_url"
    t.string "result"
    t.text "options", default: [], array: true
    t.integer "budget"
    t.index ["admin_id"], name: "index_games_on_admin_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.bigint "user_id"
    t.text "players", default: [], array: true
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_leagues_on_user_id"
  end

  create_table "likables", force: :cascade do |t|
    t.bigint "user_id_id"
    t.integer "likable_id"
    t.string "likable_type"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id_id"], name: "index_likables_on_user_id_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "player_id"
    t.string "name"
    t.string "image"
    t.string "position"
    t.string "team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "salary"
    t.json "prediction"
    t.string "opponent"
  end

  create_table "posts", force: :cascade do |t|
    t.string "post_id"
    t.string "question"
    t.json "answer", default: []
    t.json "message", default: []
    t.json "winners", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "i_message", default: []
    t.json "answer_taken", default: []
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "week"
    t.datetime "game_time"
    t.string "away_team"
    t.string "home_team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_day"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "player_id"
    t.integer "games"
    t.integer "pass_yards"
    t.integer "touchdowns"
    t.integer "interceptions"
    t.integer "rush_yards"
    t.integer "rush_touchdowns"
    t.integer "receptions"
    t.integer "reception_yards"
    t.integer "reception_touchdowns"
    t.integer "sacks"
    t.integer "ppg"
    t.integer "fantasy_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "week"
    t.index ["player_id"], name: "index_scores_on_player_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "profile_picture"
    t.string "locale"
    t.integer "timezone"
    t.string "sender_id"
    t.string "fb_id"
    t.string "fb_token"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "user_leagues", default: [], array: true
    t.text "friends", default: [], array: true
  end

end
