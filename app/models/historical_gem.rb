class HistoricalGem < ActiveRecord::Base
  belongs_to :ruby_gem, :foreign_key => :gem_id

private
  def app_params
    params.require(:historical_gem).permit(:build_date, :version)
  end
end
