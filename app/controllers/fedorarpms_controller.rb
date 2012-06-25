class FedorarpmsController < ApplicationController

  def index
    @page_title = 'All Rpm'
    @rpms = FedoraRpm.paginate(:page => params[:page], :per_page => 100)
    # @rpms = FedoraRpm.limit(100)
  end

  def show
    @id = params[:id]
    @rpm = FedoraRpm.find_by_id(@id, :include => :rpm_comments)
    @page_title = @rpm.name
  end

end
