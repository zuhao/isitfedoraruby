class StatsController < ApplicationController
  def index
    @rpms = FedoraRpm.order('commits desc').limit(10)
    @gems = RubyGem.order('downloads desc').limit(10)
  end
end
