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

class Build < ActiveRecord::Base
  belongs_to :fedora_rpm

  KOJI_API_URL = "http://koji.fedoraproject.org/kojihub"
  KOJI_BUILD_URL = "http://koji.fedoraproject.org/koji/buildinfo?buildID="

  def build_url
    KOJI_BUILD_URL + build_id.to_s
  end
end
