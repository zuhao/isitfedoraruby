require 'rails_helper.rb'

feature 'GET/ Gem foo' do

  scenario 'show source uri if different than homepage' do
    @gem = create(:foo)
    visit 'rubygems/foo'
    expect(page).to have_content "Source Code: #{@gem.source_uri}"
  end

  scenario 'hide source uri if same as homepage' do
    @gem = create(:foo)
    @gem.source_uri = @gem.homepage
    @gem.save!
    visit 'rubygems/foo'
    expect(page).to_not have_content "Source Code: #{@gem.source_uri}"
  end

  scenario 'hide source uri if nil' do
    @gem = create(:foo)
    @gem.source_uri = nil
    @gem.save!
    visit 'rubygems/foo'
    expect(page).to_not have_content "Source Code: "
  end
end
