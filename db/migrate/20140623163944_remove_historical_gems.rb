class RemoveHistoricalGems < ActiveRecord::Migration
  def up
    drop_table :historical_gems
  end

  def down
    create_table :historical_gems do |t|
      t.integer :gem_id
      t.string :version
      t.string :build_date

      t.timestamps
    end
  end
end
