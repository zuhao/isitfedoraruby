class RpmSpec < ActiveRecord::Base
  belongs_to :gem_spec
  has_many :rpm_comment, :dependent => :destroy, :order => 'created_at desc'
end
