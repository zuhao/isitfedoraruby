class Bug < ActiveRecord::Base
  attr_accessible :name, :bz_id, :is_review
  belongs_to :fedora_rpm

  def url
    "https://bugzilla.redhat.com/show_bug.cgi?id=#{bz_id}"
  end
end
