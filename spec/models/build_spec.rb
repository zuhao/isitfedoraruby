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

  let (:koji_build) { Build.new(build_id: 12345) }

  it 'has valid url' do
    expect(koji_build.build_url).to match(/#{Regexp.quote(Build::KOJI_BUILD_URL)}\d+/)
  end

end
