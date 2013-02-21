require 'text'

class SearchesController < ApplicationController

  def index
    @page_title = 'Search'
    searchphrase = params[:id]
    @results = RubyGem.where('name LIKE ?', "%#{searchphrase}%").paginate(:page => params[:page], :per_page => 50, :group => "name", :order => "length(name) asc")
    @suggests = []
    if @results == []
      all_gems = RubyGem.select('name').map{|x| x.name}
      dist_score = Hash[all_gems.map{|x| [x, Text::Levenshtein.distance(x, searchphrase)]}]
      dist_score = dist_score.sort_by{|x,d| d}.collect{|x,d| x}
      sim_score = Hash[all_gems.map{|x| [x, Text::WhiteSimilarity.similarity(x, searchphrase)]}]
      sim_score = sim_score.sort_by{|x,s| s}.reverse.collect{|x,s| x}
      # suggestions are intersection of max similarity and min Levenshtein distance
      # 50 is arbitrary, usually it is more than enough to give a good result.
      @suggests = sim_score[0..50] & dist_score[0..50]
      # give maximum 5 suggestions
      @suggests = @suggests[0..4].map{|x| RubyGem.find_by_name(x)}
    end
  end

  def suggest_gems (result = [])
    @gems = RubyGem.where("name like ?", "%#{params[:q]}%").limit(10)
    @gems.each { |g|
      result << {:name => g.name}
      }
    respond_to do |format|
      format.json { render :json => result.to_json }
    end
  end

  def redirect
    if params[:search]
      redirect_to searches_path + "/#{params[:search]}"
    end
  end
end
