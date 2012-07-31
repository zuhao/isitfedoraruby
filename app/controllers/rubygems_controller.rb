class RubygemsController < ApplicationController

  def index
    @page_title = 'Ruby Gems'
    @gems = RubyGem.paginate(:page => params[:page], :per_page => 50, :order => 'name')
  end

  def show
    @id = params[:id]
    @gem = RubyGem.find_by_id(@id, :include => :gem_comments)
    @page_title = @gem.name
    @dependencies = @gem.dependency_packages
    @dependents   = @gem.dependent_packages
  end

end
