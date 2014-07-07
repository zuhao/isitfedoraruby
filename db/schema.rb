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

ActiveRecord::Schema.define(version: 20140706211256) do

  create_table "bugs", force: true do |t|
    t.string   "name"
    t.string   "bz_id"
    t.integer  "fedora_rpm_id"
    t.boolean  "is_review"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_updated"
  end

  create_table "dependencies", force: true do |t|
    t.string   "environment"
    t.string   "dependent",         null: false
    t.string   "dependent_version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "package_id"
    t.string   "package_type"
  end

  create_table "fedora_rpms", force: true do |t|
    t.string   "name",                            null: false
    t.string   "source_uri"
    t.string   "last_commit_message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner"
    t.string   "last_committer"
    t.datetime "last_commit_date"
    t.string   "last_commit_sha"
    t.string   "homepage"
    t.integer  "ruby_gem_id"
    t.integer  "commits"
    t.string   "owner_email"
    t.text     "summary",             limit: 255
    t.text     "description",         limit: 255
  end

  create_table "gem_versions", force: true do |t|
    t.string   "gem_version"
    t.integer  "ruby_gem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "koji_builds", force: true do |t|
    t.string   "name"
    t.string   "build_id"
    t.integer  "fedora_rpm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rpm_versions", force: true do |t|
    t.integer  "fedora_rpm_id"
    t.string   "rpm_version"
    t.string   "fedora_version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_patched"
  end

  create_table "ruby_gems", force: true do |t|
    t.string   "name",                    null: false
    t.text     "description", limit: 255
    t.string   "homepage"
    t.string   "version"
    t.boolean  "has_rpm"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "downloads"
    t.string   "source_uri"
  end

end
