class Build < ActiveRecord::Base
  belongs_to :fedora_rpm

  KOJI_API_URL = "http://koji.fedoraproject.org/kojihub"
  KOJI_BUILD_URL = "http://koji.fedoraproject.org/koji/buildinfo?buildID="

  def build_url
    KOJI_BUILD_URL + build_id.to_s
  end
end
