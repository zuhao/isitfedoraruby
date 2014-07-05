# == Schema Information
#
# Table name: bugs
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  bz_id         :string(255)
#  fedora_rpm_id :integer
#  is_review     :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  last_updated  :string(255)
#

# Find bugs assigned to each packaged gem
class Bug < ActiveRecord::Base
  belongs_to :fedora_rpm

  def url
    "https://bugzilla.redhat.com/show_bug.cgi?id=#{bz_id}"
  end
end
