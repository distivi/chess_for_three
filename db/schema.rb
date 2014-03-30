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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140330213704) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "desks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "figures", force: true do |t|
    t.string   "name"
    t.integer  "figure_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "square_id"
  end

  add_index "figures", ["square_id"], name: "index_figures_on_square_id", using: :btree
  add_index "figures", ["user_id"], name: "index_figures_on_user_id", using: :btree

  create_table "squares", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "figure_id"
    t.integer  "desk_id"
  end

  add_index "squares", ["desk_id"], name: "index_squares_on_desk_id", using: :btree
  add_index "squares", ["figure_id"], name: "index_squares_on_figure_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "color"
    t.integer  "desk_id"
    t.boolean  "is_waiting"
  end

  add_index "users", ["desk_id"], name: "index_users_on_desk_id", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
