class RubygemsController < ApplicationController
  
  def all
    @page_title = 'All Gems'
    @gems = RubyGem.limit(100)
  end

  def show
    @gem = RubyGem.find_by_id(params[:id])
    @page_title = @gem.name
  end
  
end
