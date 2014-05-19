class Dependency < ActiveRecord::Base

  belongs_to :package, polymorphic: true

  def dependent_package
    if package_type == 'FedoraRpm'
      FedoraRpm.find_by_name('rubygem-' + dependent)
    else
      RubyGem.find_by_name(dependent)
    end
  end

private

  validates_presence_of :dependent

end
