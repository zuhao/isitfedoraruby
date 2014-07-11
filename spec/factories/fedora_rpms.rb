# == Schema Information
#
# Table name: fedora_rpms
#
#  id                  :integer          not null, primary key
#  name                :string(255)      not null
#  source_uri          :string(255)
#  last_commit_message :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  owner               :string(255)
#  last_committer      :string(255)
#  last_commit_date    :datetime
#  last_commit_sha     :string(255)
#  homepage            :string(255)
#  ruby_gem_id         :integer
#  commits             :integer
#  fas_name            :string(255)
#  summary             :text(255)
#  description         :text(255)
#

FactoryGirl.define do
  factory :fedora_rpm do |f|
    f.name 'rubygem-foo'
    f.source_uri 'http://pkgs.fedoraproject.org/cgit/rubygem-foo.git'
  end
end
