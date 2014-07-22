# == Schema Information
#
# Table name: bugs
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  bz_id         :string(255)
#  fedora_rpm_id :integer
#  is_review     :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  last_updated  :string(255)
#  is_open       :boolean
#

require 'rails_helper'

describe Bug do

  it 'has valid factory' do
    expect(create(:bug)).to be_valid
  end

  before(:all) do
    @bug = create(:bug)
    @bugzilla_url = 'https://bugzilla.redhat.com/show_bug.cgi?id='
  end

  it 'has valid bugzilla url' do
    expect(@bug.url).to match(/#{Regexp.quote(@bugzilla_url)}\d+/)
  end

  it 'bug is a Review Request' do
    expect(@bug.is_review).to eq true
  end

  it 'bug is not a Review Request' do
    @bug.is_review = false
    expect(@bug.is_review).to_not eq true
  end
end
