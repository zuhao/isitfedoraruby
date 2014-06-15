# == Schema Information
#
# Table name: dependencies
#
#  id                :integer          not null, primary key
#  environment       :string(255)
#  dependent         :string(255)      not null
#  dependent_version :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  package_id        :integer
#  package_type      :string(255)
#

# Used for extracting gem dependencies for RubyGem and FedoraRpm classes
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

  validates :dependent, presence: true
end
