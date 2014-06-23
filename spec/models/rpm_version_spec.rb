# == Schema Information
#
# Table name: rpm_versions
#
#  id             :integer          not null, primary key
#  fedora_rpm_id  :integer
#  rpm_version    :string(255)
#  fedora_version :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  is_patched     :boolean
#

require 'rails_helper'

describe RpmVersion do

  it "to_s" do
  end

  it "belongs to fedora rpm" do
  end

end
