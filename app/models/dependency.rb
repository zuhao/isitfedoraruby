class Dependency < ActiveRecord::Base

  belongs_to :package, :polymorphic => true

private

  validates_uniqueness_of :dependent, :scope => :environment
  validates_presence_of :dependent

end
