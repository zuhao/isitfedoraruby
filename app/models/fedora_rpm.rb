class FedoraRpm < ActiveRecord::Base
  
  belongs_to :ruby_gem
  has_many :rpm_comment, :dependent => :destroy, :order => 'created_at desc'
  has_many :working_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => true}
  has_many :failure_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => false}
  scope :popular, :order => 'rpm_comments_count desc'

  def self.new_from_rpm_tuple(rpm_tuple)
    spec = rpm_tuple["packageListings"][0]["package"]
    f = find_or_initialize_by_name(spec["name"])
    if f.new_record?
      f.description = spec["summary"]
      f.homepage = 'https://admin.fedoraproject.org/pkgdb/acls/name/' + spec["name"]
      f.save!
      logger.info("Rpm #{f.name} imported")
    else
      logger.info("Rpm #{f.name} already existed")
    end
  rescue => e
    logger.info("Could not create rpm spec for #{spec["name"]}")
  end

  def rpm_name
    self.name
  end

  def works?
    has_no_failure_comments? && has_working_comments?
  end

  def hotness
    total = RpmComment.count
    total = 1 if total == 0
    RpmComment.working.count * 100 / total
  end

private
  
  validates_uniqueness_of :name
  validates_presence_of :name

end
