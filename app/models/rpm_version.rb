class RpmVersion < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :fedora_rpm
end
