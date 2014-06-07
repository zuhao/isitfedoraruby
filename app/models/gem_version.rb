# == Schema Information
#
# Table name: gem_versions
#
#  id          :integer          not null, primary key
#  gem_version :string(255)
#  ruby_gem_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class GemVersion < ActiveRecord::Base
  belongs_to :ruby_gem
end
