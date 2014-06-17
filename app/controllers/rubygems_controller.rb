class RubygemsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @page_title = 'Ruby Gems'
    @gems = RubyGem.paginate(page: params[:page], per_page: 50)
                   .order(sort_column + ' ' + sort_direction)
  end

  def show
    @name = params[:id]
    @gem = RubyGem.find_by_name(@name)
    @page_title = @gem.name
    @dependencies = @gem.dependency_packages
    @dependents   = @gem.dependent_packages
  end

  private

  def sort_column
    %w(name downloads).include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
