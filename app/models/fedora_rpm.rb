class FedoraRpm < ActiveRecord::Base

  belongs_to :ruby_gem
  has_many :rpm_comments, :dependent => :destroy, :order => 'created_at desc'
  has_many :working_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => true}
  has_many :failure_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => false}
  scope :popular, :order => 'rpm_comments_count desc'

  def self.new_from_rpm_tuple(rpm_tuple)
    # it comes in "rpm_name.git firstname+lastname" format
    rpm = rpm_tuple.split.first
    f = find_or_initialize_by_name(rpm.gsub(/\.git/,''))
    f.name = rpm.gsub(/\.git/,'')
    f.author = rpm_tuple.split.last.gsub(/\+/,' ')
    f.git_url = "git://pkgs.fedoraproject.org/#{rpm}"
    f.ruby_gem = RubyGem.find_by_name(f.name.gsub(/rubygem-/,''))

    begin
      rpm_spec = URI.parse("#{RpmImporter::RPM_SPEC_URI};p=#{rpm};f=#{rpm.gsub(/git$/,'spec')}").read
      f.version = rpm_spec.scan(/\nVersion: .*\n/).first.split.last
      f.homepage = rpm_spec.scan(/\nURL: .*\n/).first.split.last
      # TODO: more info can be extracted
    rescue OpenURI::HTTPError
      # some rpms do not have spec file
    rescue NoMethodError
      # some spec files do not have Version or URL
    end

    begin
      g = f.ruby_gem
      g.has_rpm = true
      g.save
    rescue NoMethodError
      # some rpm does not have corresponding gem
    end

    f.save!
    logger.info("Rpm #{f.name} imported")
  rescue => e
    logger.info("Could not import #{rpm_tuple.split.first}")
  end

  def rpm_name
    self.name
  end

  def works?
    has_no_failure_comments? && has_working_comments?
  end

  def hotness
    total = self.rpm_comments.count
    total = 1 if total == 0
    self.rpm_comments.working.count * 100 / total
  end

private

  validates_uniqueness_of :name
  validates_presence_of :name

end
