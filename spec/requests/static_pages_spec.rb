require 'rails_helper'

describe "Static Pages" do

  describe "Success Stories" do
    it "should have the title 'Success Stories'" do
      visit '/successes'
      page.should have_selector('title', :text => 'Success Stories')
    end
    # it "should have the content 'Success Stories'" do
    #   visit '/successes'
    #   page.should have_content('Success Stories')
    # end
  end

  describe "Contribute" do
    it "should have the title 'Contribute'" do
      visit '/contribute'
      page.should have_selector('title', :text => 'Contribute')
    end
    # it "should have the content 'Contribute'" do
    #   visit '/contribute'
    #   page.should have_content('Contribute')
    # end
  end

end
