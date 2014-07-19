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
require 'faker'
require Rails.root.join('spec', 'support', 'datetime')

FactoryGirl.define do
  factory :rubygem_foo, class: FedoraRpm do
    name 'rubygem-foo'
    source_uri 'http://pkgs.fedoraproject.org/cgit/rubygem-foo.git'
    owner Faker::Internet.user_name
    homepage Faker::Internet.url
    commits Faker::Number.number(2)
    owner_email { '#{name}-#{owner}@fedoraproject.org' }
    summary Faker::Lorem.sentence
    description Faker::Lorem.paragraph
    # rubygem_foo belongs to foo in factories/ruby_gems.rb
    association :ruby_gem, factory: :foo

    trait :last_committer_set do
      last_committer Faker::Name.name
    end

    trait :last_committer_not_set do
      last_committer nil
    end

    trait :last_commit_date_set do
      last_commit_date RandomDate.date
    end

    trait :last_commit_date_not_set do
      last_commit_date nil
    end

    trait :last_commit_message_set do
      last_commit_message Faker::Lorem.sentence
    end

    trait :last_commit_message_not_set do
      last_commit_message nil
    end

    factory :rpm_last_commit_message_set, traits: [:last_commit_message_set]
    factory :rpm_last_commit_message_not_set, traits: [:last_commit_message_not_set]
    factory :rpm_last_commit_date_set, traits: [:last_commit_date_set]
    factory :rpm_last_commit_date_not_set, traits: [:last_commit_date_not_set]
    factory :rpm_committer_set, traits: [:last_committer_set]
    factory :rpm_committer_not_set, traits: [:last_committer_not_set]

  end
end
