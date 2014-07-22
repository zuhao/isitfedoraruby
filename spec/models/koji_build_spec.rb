# == Schema Information
#
# Table name: koji_builds
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  build_id      :string(255)
#  fedora_rpm_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

describe KojiBuild do

  it 'has valid url' do
    expect(build(:koji_build).build_url).to \
      match(/#{Regexp.quote(KojiBuild::KOJI_BUILD_URL)}\d+/)
  end

end
