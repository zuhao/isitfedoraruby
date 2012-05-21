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

ActiveRecord::Schema.define(:version => 20120521135403) do

  create_table "gem_comments", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "text"
    t.boolean  "want_it"
    t.boolean  "receive_update"
    t.integer  "gem_specs_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "gem_specs", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.string   "rubygems"
    t.string   "version"
    t.boolean  "has_rpm"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "rpm_comments", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "text"
    t.boolean  "works_for_me"
    t.boolean  "receive_update"
    t.integer  "rpm_specs_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "rpm_specs", :force => true do |t|
    t.string   "name",          :null => false
    t.string   "description"
    t.string   "fedorapkg"
    t.string   "rpm_version"
    t.string   "patch_version"
    t.string   "patch_summary"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
