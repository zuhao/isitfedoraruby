class GemcommentsController < ApplicationController
  def index
    @gem = RubyGem.find_by_id(params[:id])
  end

  def create
    @gem = RubyGem.find_by_id(params[:id])
    @comment = @gem.gem_comments.build(params[:gem_comment])
    @comment.save!
  end

end
