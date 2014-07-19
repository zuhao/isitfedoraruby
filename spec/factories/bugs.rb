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
#
FactoryGirl.define do
  factory :bug do
    name 'Review Request: rubygem-foo - Short summary'
    bz_id '12345'
    is_review true
    last_updated '6 days and 3 hours'
  end
end
