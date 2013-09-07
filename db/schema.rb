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

ActiveRecord::Schema.define(version: 20130906230105) do

  create_table "courses", force: true do |t|
    t.integer  "user_id"
    t.integer  "crse_id"
    t.string   "subject"
    t.integer  "catalog_nbr"
    t.string   "institution"
    t.string   "acad_career"
    t.string   "course_title_long"
    t.integer  "class_nbr"
    t.string   "ssr_component"
    t.string   "ssr_mtg_sched_long"
    t.string   "ssr_instr_long"
    t.string   "ssr_mtg_dt_long"
    t.string   "ssr_mtg_loc_long"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["class_nbr"], name: "index_courses_on_class_nbr"
  add_index "courses", ["subject"], name: "index_courses_on_subject"
  add_index "courses", ["user_id"], name: "index_courses_on_user_id"

  create_table "office_hours", force: true do |t|
    t.integer  "course_id"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "location"
    t.string   "description"
    t.boolean  "default",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "office_hours", ["course_id"], name: "index_office_hours_on_course_id"

  create_table "users", force: true do |t|
    t.string   "net_id"
    t.string   "ldapkey"
    t.string   "display_name"
    t.string   "givenName"
    t.string   "sn"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "instructor",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["net_id"], name: "index_users_on_net_id"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", unique: true

end
