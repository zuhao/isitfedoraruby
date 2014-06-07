# == Schema Information
#
# Table name: dependencies
#
#  id                :integer          not null, primary key
#  environment       :string(255)
#  dependent         :string(255)      not null
#  dependent_version :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  package_id        :integer
#  package_type      :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dependency do
  end
end
