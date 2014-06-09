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
  it "has valid factory" do
    expect(FactoryGirl.create(:bug)).to be_valid
  end

  before(:all) do
    @bug = FactoryGirl.create(:bug)
    @bugzilla_url = "https://bugzilla.redhat.com/show_bug.cgi?id="
  end

  it "has valid bugzilla url" do
    expect(@bug.url).to match /#{Regexp.quote(@bugzilla_url)}\d+/
  end

  it "bug is a Review Request" do
    @bug.is_review = true
    expect(@bug.is_review).to eq true
  end

  it "bug is open" do
   @bug.is_open = true
   expect(@bug.is_open).to eq true
  end

  it "bug is closed" do
   @bug.is_open = false
   expect(@bug.is_open).to eq false
  end

end

