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
    create(:rubygem_foo)
  end

  scenario 'has title' do
    visit 'fedorarpms/rubygem-foo'
    expect(page).to have_content 'rubygem-foo'
    expect(page).to_not have_content 'RPM Not Found'
  end
end
