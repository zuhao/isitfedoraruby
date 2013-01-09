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

ActiveRecord::Schema.define(:version => 20130103111220) do

  create_table "bugs", :force => true do |t|
    t.string   "name"
    t.string   "bz_id"
    t.integer  "fedora_rpm_id"
    t.boolean  "is_review"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "last_updated"
  end

  create_table "builds", :force => true do |t|
    t.string   "name"
    t.string   "build_id"
    t.integer  "fedora_rpm_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "dependencies", :force => true do |t|
    t.string   "environment"
    t.string   "dependent",         :null => false
    t.string   "dependent_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "package_id"
    t.string   "package_type"
  end

  create_table "fedora_rpms", :force => true do |t|
    t.string   "name",                :null => false
    t.string   "source_uri"
    t.string   "latest_patch"
    t.string   "last_commit_message"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "author"
    t.string   "last_committer"
    t.datetime "last_commit_date"
    t.string   "last_commit_sha"
    t.string   "homepage"
    t.integer  "ruby_gem_id"
    t.integer  "commits"
    t.string   "fedora_user"
    t.string   "summary"
    t.string   "description"
  end

  create_table "gem_comments", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "text"
    t.boolean  "want_it"
    t.boolean  "receive_update"
    t.integer  "ruby_gem_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "historical_gems", :force => true do |t|
    t.integer  "gem_id"
    t.string   "version"
    t.string   "build_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rpm_comments", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "text"
    t.boolean  "works_for_me"
    t.boolean  "receive_update"
    t.integer  "fedora_rpm_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "rpm_versions", :force => true do |t|
    t.integer  "fedora_rpm_id"
    t.string   "rpm_version"
    t.string   "fedora_version"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.boolean  "is_patched"
  end

  create_table "ruby_gems", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.string   "homepage"
    t.string   "version"
    t.boolean  "has_rpm"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "downloads"
    t.string   "source_uri"
  end

end
