class HomeController < ApplicationController
  def show
    @page_title = 'Welcome'
    @popular_gems = RubyGem.most_popular.limit(10)
    @recent_rpms = FedoraRpm.most_recent.limit(10)
  end
end
