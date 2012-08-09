class FedorarpmsController < ApplicationController

  helper_method :sort_column, :sort_direction

  def index
    @page_title = 'Fedora Rpms'
    @rpms = FedoraRpm.paginate(:page => params[:page], :per_page => 50).order(sort_column + " " + sort_direction)
  end

  def show
    @name = params[:name]
    @rpm = FedoraRpm.find_by_name(@name, :include => :rpm_comments)
    @page_title = @rpm.name
    @dependencies = @rpm.dependency_packages
    @dependents = @rpm.dependent_packages
  end

private

  def sort_column
    %w[name commits last_commit_date].include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
