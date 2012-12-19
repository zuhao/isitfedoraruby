class SearchesController < ApplicationController

  def index
    @page_title = 'Search'
    searchphrase = params[:search]
	query = <<-QUERY 
		CASE WHEN name like ? THEN 0
        WHEN name like ? THEN 1
        WHEN name like ? THEN 2 
        ELSE 3 END, name
        QUERY
    sanitized_order = ActiveRecord::Base.send :sanitize_sql_array, [query,searchphrase+'%','% %' + searchphrase + '% %', '%'+searchphrase]
    @results = RubyGem.where(
        'name LIKE ?', "%#{searchphrase}%"
    ).paginate(
        :page => params[:page], 
        :per_page => 50, 
        :group => "name", 
        :order => sanitized_order
    )
  end
  
end
