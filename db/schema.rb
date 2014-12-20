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

ActiveRecord::Schema.define(version: 20141220151023) do

  create_table "candidates", force: true do |t|
    t.integer  "poll_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "candidates", ["poll_id"], name: "index_candidates_on_poll_id"

  create_table "polls", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", force: true do |t|
    t.integer  "poll_id"
    t.integer  "candidate_id"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["poll_id"], name: "index_votes_on_poll_id"

end
