class RpmcommentsController < ApplicationController
  def index
    @rpm = FedoraRpm.find_by_id(params[:id])
  end

  def create
    @rpm = FedoraRpm.find_by_id(params[:id])
    @rpm_comment = @rpm.rpm_comments.build(params[:rpm_comment])
    if @rpm_comment.save
      redirect_to fedorarpm_path(@rpm)
    else

    end
  end

end
