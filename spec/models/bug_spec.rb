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
  it "has valid bugzilla url" do
    @url = Bug.new
    expect(@url).to match(/#{@url}\d+/)
  end
end
