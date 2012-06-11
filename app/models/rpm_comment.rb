class RpmComment < ActiveRecord::Base
  
  belongs_to :fedora_rpm
  scope :latest, :order => 'created_at desc'
  scope :working, where(:works_for_me => true)
  scope :receive_update, where(:receive_update == true && :email != nil)
  delegate :rpm_name, :to => :fedora_rpm

  def initialize params = nil
    super
    self.works_for_me ||= true unless self.works_for_me == false
    self.receive_update ||= true unless self.receive_update == false
  end

  def description
    verb = self.works_for_me ? 'works' : 'fails'
    "#{rpm_name} #{verb} for #{name}!"
  end

private

  validates_presence_of :fedora_rpm, :name
  validates_format_of :email, :with => /^([_a-z0-9\+\.\-]+\@[_a-z0-9\-]+\.[_a-z0-9\.\-]+)$/i

end
