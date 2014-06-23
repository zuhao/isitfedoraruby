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

require 'rails_helper'

describe Dependency do

  xit "dependent_package" do
  end

  # validate dependent
  xit "should have dependent gem" do
  end

end
