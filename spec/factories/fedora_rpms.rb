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
#  owner_email         :string(255)
#  summary             :text(255)
#  description         :text(255)
#

FactoryGirl.define do
  factory :rubygem_foo, class: FedoraRpm do
    name 'rubygem-foo'
    source_uri 'http://pkgs.fedoraproject.org/cgit/rubygem-foo.git'
    owner 'thedude'
    homepage 'http://example.com/foo'
    commits '4'
    owner_email 'rubygem-foo-owner@fedoraproject.org'
    summary 'A tiny library for fooing bars.'
    description 'Ever wondered what is like fooing bars? Find out now!'

    # rubygem_foo belongs to foo in factories/ruby_gems.rb
    association :ruby_gem, factory: :foo
  end
end
