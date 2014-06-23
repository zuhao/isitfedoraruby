# == Schema Information
#
# Table name: builds
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  build_id      :string(255)
#  fedora_rpm_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

describe Build do

  xit "build_url" do
  end

end
