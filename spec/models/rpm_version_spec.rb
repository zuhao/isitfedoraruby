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

RSpec.describe RpmVersion, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
