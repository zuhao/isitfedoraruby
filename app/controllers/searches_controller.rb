class SearchesController < ApplicationController

  def index
    @page_title = 'Search'
    searchphrase = params[:search]
    @results = RubyGem.where('name LIKE ?', "%#{searchphrase}%").paginate(:page => params[:page], :per_page => 50, :group => "name", :order => "length(name) asc")
  end
  
end