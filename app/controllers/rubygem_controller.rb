class RubygemController < ApplicationController
  def all
    @page_title = 'All Gems'
    @gems = RubyGem.limit(100)
  end

  def index
    
  end

  def show
    
  end

end
