class RpmcommentsController < ApplicationController
  def index
    @rpm = FedoraRpm.find_by_name(params[:name])
  end

  def create
    @rpm = FedoraRpm.find_by_name(params[:name])
    @rpm_comment = @rpm.rpm_comments.build(params[:rpm_comment])
    if @rpm_comment.save
      redirect_to fedorarpm_path(@rpm)
    else

    end
  end

end
