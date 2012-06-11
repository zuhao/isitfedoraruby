class GemComment < ActiveRecord::Base
  
  belongs_to :ruby_gem
  scope :latest, :order => 'created_at desc'
  scope :wanted, where(:want_it => true)
  scope :receive_update, where(:receive_update == true && :email != nil)
  delegate :gem_name, :to => :ruby_gem

  def initialize params = nil
    super
    self.want_it ||= true unless self.want_it == false
    self.receive_update ||= true unless self.receive_update == false
  end

  def description
    # requestor = self.name ||= 'Anonymous'
    "#{name} wants #{gem_name}!"
  end

private

  validates_presence_of :ruby_gem, :name
  validates_format_of :email, :with => /^([_a-z0-9\+\.\-]+\@[_a-z0-9\-]+\.[_a-z0-9\.\-]+)$/i

end
