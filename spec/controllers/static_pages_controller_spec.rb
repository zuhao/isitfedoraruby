require 'rails_helper'

describe StaticPagesController do

  describe "GET 'successes'" do
    xit 'returns http success' do
      get 'successes'
      response.should be_success
    end
  end

  describe "GET 'contribute'" do
    xit 'returns http success' do
      get 'contribute'
      response.should be_success
    end
  end

end
