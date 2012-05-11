class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :name
      t.string :email
      t.text :text
      t.boolean :works_for_me
      t.boolean :want_it
      t.boolean :receive_update?
      t.references :rpm_specs, :gem_specs
      t.timestamps
    end
  end
end
