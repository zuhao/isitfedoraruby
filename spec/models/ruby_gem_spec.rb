# == Schema Information
#
# Table name: ruby_gems
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text(255)
#  homepage    :string(255)
#  version     :string(255)
#  has_rpm     :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  downloads   :integer
#  source_uri  :string(255)
#

require 'rails_helper'

describe RubyGem do

  xit 'to_param' do
  end

  xit 'load_or_create' do
  end

  xit 'on_rubygems?' do
  end

  xit 'retrieve_metadata' do
  end

  xit 'retrieve_rpm' do
  end

  xit 'retrieve_versions' do
  end

  xit 'update_from_source' do
  end

  xit 'search' do
  end

  xit 'gem_name' do
  end

  xit 'rpm?' do
  end

  xit 'version_in_fedora' do
  end

  xit 'upto_date_in_fedora' do
  end

  xit 'depencency_packages' do
  end

  xit 'dependent_packages' do
  end

  xit 'uri_for_version' do
  end

  xit 'download_version' do
  end

  xit 'download' do
  end

  xit 'description_string' do
  end

end
