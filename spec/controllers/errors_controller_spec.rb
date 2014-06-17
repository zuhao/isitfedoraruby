require 'rails_helper'

describe ErrorsController do

  describe "GET 'error_404'" do
    xit 'returns http success' do
      get 'error_404'
      response.should be_success
    end
  end

  describe "GET 'error_500'" do
    xit 'returns http success' do
      get 'error_500'
      response.should be_success
    end
  end

end
