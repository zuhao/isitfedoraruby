class FedorarpmsController < ApplicationController

  def all
    @page_title = 'All Rpm'
    @rpms = FedoraRpm.limit(100)
  end

  def show
    @rpm = FedoraRpm.find_by_id(params[:id])
    @page_title = @rpm.name
  end

end
