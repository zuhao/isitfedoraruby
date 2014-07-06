require 'rails_helper.rb'

feature 'Fedora Rpms index page' do

  background do
    visit fedorarpms_path
  end

  scenario 'has title Fedora RPMs' do
    expect(page).to have_content 'Fedora RPMs'
  end

  scenario 'has a table' do
    expect(page.find(:xpath, "//table"))
  end

end

feature 'Fedora Rpm show page' do
  background do
    create(:fedora_rpm)
  end

  scenario 'has title' do
    visit 'fedorarpms/rubygem-foo'
    expect(page).to have_content 'rubygem-foo'
  end
end
