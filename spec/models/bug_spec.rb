require 'rails_helper'

describe Bug do
  it "has valid bugzilla url" do
    @url = Bug.new
    expect(@url).to match(/#{@url}\d+/)
  end
end
