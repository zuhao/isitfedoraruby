class RubygemsController < ApplicationController

  def index
    @page_title = 'All Gems'
    @gems = RubyGem.paginate(:page => params[:page], :per_page => 50, :order => 'name')
    # @gems = RubyGem.limit(100)
  end

  def show
    @id = params[:id]
    @gem = RubyGem.find_by_id(@id, :include => :gem_comments)
    @page_title = @gem.name
  end

end
