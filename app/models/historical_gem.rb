class HistoricalGem < ActiveRecord::Base
  attr_accessible :build_date, :version
  belongs_to :ruby_gem, :foreign_key => :gem_id
end
