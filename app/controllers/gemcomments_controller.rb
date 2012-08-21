class GemcommentsController < ApplicationController
  def index
    @gem = RubyGem.find_by_name(params[:id])
  end

  def create
    @gem = RubyGem.find_by_name(params[:id])
    @gem_comment = @gem.gem_comments.build(params[:gem_comment])
    if verify_recaptcha && @gem_comment.save
      redirect_to rubygem_path(@gem)
    else
      redirect_to rubygem_path(@gem)
      flash[:error] = 'Sorry, wrong CAPTCHA. Unable to save your comment.'
    end
  end

end
