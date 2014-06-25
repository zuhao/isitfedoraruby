# == Schema Information
#
# Table name: koji_builds
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  build_id      :string(255)
#  fedora_rpm_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :koji_build do |b|
    b.build_id '12345'
    b.fedora_rpm_id 42
  end
end
