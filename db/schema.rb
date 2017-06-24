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

ActiveRecord::Schema.define(version: 20170624104833) do

  create_table "players", force: :cascade do |t|
    t.text     "name"
    t.text     "image"
    t.text     "country"
    t.text     "graduate"
    t.text     "birth"
    t.text     "physical"
    t.text     "first"
    t.text     "style"
    t.text     "position"
    t.text     "draft"
    t.text     "bar"
    t.text     "career_over"
    t.text     "career_detail"
    t.text     "phonetic"
    t.text     "team"
    t.text     "wiki"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
