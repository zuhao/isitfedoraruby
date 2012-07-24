class FedorarpmsController < ApplicationController

  def index
    @page_title = 'Fedora Rpms'
    @rpms = FedoraRpm.paginate(:page => params[:page], :per_page => 50, :order => 'name')
  end

  def show
    @id = params[:id]
    @rpm = FedoraRpm.find_by_id(@id, :include => :rpm_comments)
    @page_title = @rpm.name
    @dependencies = @rpm.get_rpm_dependencies
  end

end
