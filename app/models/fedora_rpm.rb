class FedoraRpm < ActiveRecord::Base
  
  belongs_to :ruby_gem
  has_many :rpm_comment, :dependent => :destroy, :order => 'created_at desc'
  has_many :working_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => true}
  has_many :failure_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => false}
  scope :popular, :order => 'rpm_comments_count desc'

  def self.new_from_rpm_tuple(rpm_tuple)
    rpm = rpm_tuple.split.first
    # TODO: more info can be extracted 
    f = find_or_initialize_by_name(rpm.gsub(/\.git/,''))
    if f.new_record?
      f.name = rpm.gsub(/\.git/,'')
      f.author = rpm_tuple.split.last.gsub(/\+/,' ')
      f.git_url = "git://pkgs.fedoraproject.org/#{rpm}"
      rpm_spec = URI.parse("#{RPM_SPEC_URI};p=#{rpm};f=#{rpm.gsub(/git$/,'spec')}").read
      f.version = rpm_spec.scan(/\nVersion: .*\n/).first.split.last
      f.homepage = rpm_spec.scan(/\nURL: .*\n/).first.split.last
      f.ruby_gem_id = RubyGem.find_by_name(f.name.gsub(/rubygem-/,'')).id

      #f.author = rpm_tuple['author']
      #f.last_committer = rpm_tuple['last_committer']
      #f.last_commit_message = rpm_tuple['last_commit_message']
      #f.last_commit_date = rpm_tuple['last_commit_date']
      #f.last_commit_sha = rpm_tuple['last_commit_sha']

      f.save!
      logger.info("Rpm #{f.name} imported")
    else
      logger.info("Rpm #{f.name} already existed")
    end
  rescue => e
    logger.info("Could not import #{rpm_tuple['name']}")
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
