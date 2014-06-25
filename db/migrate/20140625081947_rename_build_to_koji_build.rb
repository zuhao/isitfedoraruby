class RenameBuildToKojiBuild < ActiveRecord::Migration
  def change
    rename_table :builds, :koji_builds
  end
end
