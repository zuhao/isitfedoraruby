class SearchesController < ApplicationController

  def index
    @page_title = 'Search'
    searchphrase = params[:search]
    @results = RubyGem.where('name LIKE ?', "%#{searchphrase}%").paginate(:page => params[:page], :per_page => 50, :group => "name", :order => "length(name) asc")
  end
  
  def suggest_gems (result = [])
    @gems = RubyGem.where("name like ?", "%#{params[:q]}%").limit(10)
    @gems.each { |g|
      result << {:name => g.name}
      } 
    respond_to do |format|
      format.json { render :json => result.to_json }
    end
  end 
end
