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

FactoryGirl.define do
  factory :dependency do
    environment 'runtime'
    dependent 'bar'
    dependent_version '1.0.1'
    package_id 1
    package_type 'FedoraRpm'
  end
end
