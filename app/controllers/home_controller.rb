class HomeController < ApplicationController
  def show
    @page_title = _('Welcome')
    @popular_gems = RubyGem.most_popular.limit(10)
    @popular_rpms = FedoraRpm.most_popular.limit(10)
    @wanted_gems = RubyGem.most_wanted.limit(10)
    @recent_rpms = FedoraRpm.most_recent.limit(10)
  end
end
