class FedorarpmsController < ApplicationController

  def index
    @page_title = 'Fedora Rpms'
    @rpms = FedoraRpm.paginate(:page => params[:page], :per_page => 50, :order => 'name')
  end

  def show
    @name = params[:name]
    @rpm = FedoraRpm.find_by_name(@name, :include => :rpm_comments)
    @page_title = @rpm.name
    @dependencies = @rpm.dependency_packages
    @dependents = @rpm.dependent_packages
  end

end
