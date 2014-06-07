# == Schema Information
#
# Table name: historical_gems
#
#  id         :integer          not null, primary key
#  gem_id     :integer
#  version    :string(255)
#  build_date :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class HistoricalGem < ActiveRecord::Base
  belongs_to :ruby_gem, :foreign_key => :gem_id

private
  def app_params
    params.require(:historical_gem).permit(:build_date, :version)
  end
end
