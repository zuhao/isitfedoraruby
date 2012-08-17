class Dependency < ActiveRecord::Base

  belongs_to :package, :polymorphic => true

  def dependent_package
    package_type == "FedoraRpm" ?
      FedoraRpm.find_by_name("rubygem-" + dependent) :
      RubyGem.find_by_name(dependent)
  end

private

  validates_presence_of :dependent

end
