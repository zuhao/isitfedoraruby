class FedorarpmsController < ApplicationController

  def index
    @page_title = 'All Rpm'
    # @rpms = FedoraRpm.all
    @rpms = FedoraRpm.limit(100)
  end

  def show
    id = params[:id]
    @rpm = FedoraRpm.find_by_id(id)
    @page_title = @rpm.name
  end

end
