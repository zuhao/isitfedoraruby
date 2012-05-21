class CreateRpmComments < ActiveRecord::Migration
  def change
    create_table :rpm_comments do |t|
      t.string :name
      t.string :email
      t.text :text
      t.boolean :works_for_me
      t.boolean :receive_update
      t.references :rpm_specs
      t.timestamps
    end
  end
end
