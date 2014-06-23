# == Schema Information
# #
# # Table name: gem_versions
# #
# #  id          :integer          not null, primary key
# #  gem_version :string(255)
# #  ruby_gem_id :integer
# #  created_at  :datetime
# #  updated_at  :datetime
# #

require 'rails_helper'

describe GemVersion do

  it "belongs to rubygem" do
  end

end
