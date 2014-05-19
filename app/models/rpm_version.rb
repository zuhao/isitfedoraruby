class RpmVersion < ActiveRecord::Base
  belongs_to :fedora_rpm

  def to_s
    "#{rpm_version} (#{fedora_version}/#{is_patched ? '' : 'not'} patched)"
  end
end
