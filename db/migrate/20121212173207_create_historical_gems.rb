class CreateHistoricalGems < ActiveRecord::Migration
  def change
    create_table :historical_gems do |t|
      t.integer :gem_id
      t.string :version
      t.string :build_date

      t.timestamps
    end
  end
end
