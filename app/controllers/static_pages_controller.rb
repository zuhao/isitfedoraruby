class StaticPagesController < ApplicationController
  def successes
    @page_title = 'Success Stories'
  end

  def contribute
    @page_title = 'Contribute to make it better'
  end
end
