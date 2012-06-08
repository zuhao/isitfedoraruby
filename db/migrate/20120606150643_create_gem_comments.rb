class CreateGemComments < ActiveRecord::Migration
  def change
    create_table :gem_comments do |t|
      t.string :name
      t.string :email
      t.text :text
      t.boolean :want_it
      t.boolean :receive_update
      t.references :ruby_gem
      t.timestamps
    end
  end
end
