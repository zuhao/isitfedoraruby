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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rpm_version do
  end
end
