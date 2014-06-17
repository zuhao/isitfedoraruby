# == Schema Information
#
# Table name: ruby_gems
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text(255)
#  homepage    :string(255)
#  version     :string(255)
#  has_rpm     :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  downloads   :integer
#  source_uri  :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ruby_gem do
  end
end
