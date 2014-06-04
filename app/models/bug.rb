class Bug < ActiveRecord::Base
  belongs_to :fedora_rpm

  def url
    "https://bugzilla.redhat.com/show_bug.cgi?id=#{bz_id}"
  end
end
