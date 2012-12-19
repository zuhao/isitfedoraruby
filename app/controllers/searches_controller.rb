class SearchesController < ApplicationController

  def index
    @page_title = 'Search'
    searchphrase = params[:search]
    @results = RubyGem.search(searchphrase).paginate(:page => params[:page], :per_page => 50, :order => 'name')
  end

end
