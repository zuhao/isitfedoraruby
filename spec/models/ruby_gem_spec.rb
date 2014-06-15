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

require 'rails_helper'

RSpec.describe RubyGem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
