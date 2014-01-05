class DropCommentsTables < ActiveRecord::Migration
  def change
    drop_table :rpm_comments
    drop_table :gem_comments
  end
end
