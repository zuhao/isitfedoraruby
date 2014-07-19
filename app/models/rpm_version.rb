# == Schema Information
#
# Table name: rpm_versions
#
#  id             :integer          not null, primary key
#  fedora_rpm_id  :integer
#  rpm_version    :string(255)
#  fedora_version :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  patched        :boolean
#

# Various rpm versions of a packaged gem
class RpmVersion < ActiveRecord::Base
  belongs_to :fedora_rpm

  def to_s
    "#{rpm_version} (#{fedora_version}/#{patched ? '' : 'not'} patched)"
  end
end
