class FedoraRpm < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :ruby_gem
  has_many :rpm_comment, :dependent => :destroy, :order => 'created_at desc'

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

private
  
  validates :name, :uniqueness => true
  validates :name, :presence => true
end
