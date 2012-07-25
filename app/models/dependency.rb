class Dependency < ActiveRecord::Base

  belongs_to :package, :polymorphic => true

private

  validates_presence_of :dependent

end
