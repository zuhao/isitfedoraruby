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
  factory :ruby_gem do |r|
    r.name 'rails'
    r.description 'An awesome web framework.'
    r.homepage 'http://rubyonrails.org'
    r.version '4.1.0'
    r.has_rpm true
    r.downloads 42_000_000
    r.source_uri 'https://github/rails/rails'
  end

  factory :fakegem, class: RubyGem do |r|
    r.name 'fakegem'
    r.description nil
    r.homepage nil
    r.version nil
    r.has_rpm nil
    r.downloads nil
    r.source_uri nil
  end

  factory :foo, class: RubyGem do |r|
    r.name 'foo'
    r.description 'Ever wondered what is like fooing bars? Find out now!'
    r.homepage 'http://example.com/foo'
    r.version '1.0.1'
    r.has_rpm true
    r.downloads 10
    r.source_uri 'https://git.com/foo'
  end
end
