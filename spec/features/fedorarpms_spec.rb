require 'rails_helper.rb'

feature 'GET/ Fedora Rpms index page' do

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

feature 'GET/ Fedora Rpm rubygem-foo' do

  background do
  end

  scenario 'has rubygem-foo title' do
    create(:rubygem_foo)
    visit 'fedorarpms/rubygem-foo'
    expect(page).to have_content 'rubygem-foo'
    expect(page).to_not have_content 'RPM Not Found'
  end

  scenario 'shows last packager if last_commiter is set' do
    @rpm = create(:rpm_committer_set)
    visit 'fedorarpms/rubygem-foo'
    expect(page).to have_content "Last packager: #{@rpm.last_committer}"
  end

  scenario 'does not show last packager if last_commiter is not set' do
    create(:rpm_committer_not_set)
    visit 'fedorarpms/rubygem-foo'
    expect(page).to_not have_content 'Last packager:'
  end

  scenario 'shows last date a commit was pushed' do
    @rpm = create(:rpm_last_commit_date_set)
    visit 'fedorarpms/rubygem-foo'
    expect(page).to have_content "Last commit date: #{@rpm.last_commit_date.to_s(:long)}"
  end

  scenario 'does not show last date if last commit date is missing' do
    create(:rpm_last_commit_date_not_set)
    visit 'fedorarpms/rubygem-foo'
    expect(page).to_not have_content 'Last updated:'
  end

  scenario 'shows last commit message' do
    @rpm = create(:rpm_last_commit_message_set)
    visit 'fedorarpms/rubygem-foo'
    expect(page).to have_content "Last commit message: #{@rpm.last_commit_message}"
  end

  scenario 'does not show last commit message' do
    @rpm = create(:rpm_last_commit_message_not_set)
    visit 'fedorarpms/rubygem-foo'
    expect(page).to_not have_content 'Last commit message:'
  end

end
