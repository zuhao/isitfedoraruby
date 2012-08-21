class RpmcommentsController < ApplicationController
  def index
    @rpm = FedoraRpm.find_by_name(params[:id])
  end

  def create
    @rpm = FedoraRpm.find_by_name(params[:id])
    @rpm_comment = @rpm.rpm_comments.build(params[:rpm_comment])
    if verify_recaptcha && @rpm_comment.save
      redirect_to fedorarpm_path(@rpm)
    else
      redirect_to fedorarpm_path(@rpm)
      flash[:error] = 'Sorry, wrong CAPTCHA. Unable to save your comment.'
    end
  end

end
