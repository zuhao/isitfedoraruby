require 'test_helper'

class RubygemControllerTest < ActionController::TestCase
  test "should get all" do
    get :all
    assert_response :success
  end

end
