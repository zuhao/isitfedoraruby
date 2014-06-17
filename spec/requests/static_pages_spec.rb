require 'rails_helper'

describe 'Static Pages' do

  describe 'Contribute' do
    xit "should have the title 'Contribute'" do
      visit '/contribute'
      page.should have_selector('title', text: 'Contribute')
    end
    # it "should have the content 'Contribute'" do
    #   visit '/contribute'
    #   page.should have_content('Contribute')
    # end
  end

end
