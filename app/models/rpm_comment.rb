class RpmComment < ActiveRecord::Base
  belongs_to :rpm_spec
end
