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

  describe 'Validations' do
    it { should have_one(:fedora_rpm).dependent(:destroy) }
    it { should have_many(:dependencies).dependent(:destroy) }
    it { should have_many(:gem_versions).dependent(:destroy) }
  end

  describe '#to_param' do
    it 'returns the name of the gem stored in db' do
      expect(build(:ruby_gem).name).to eq('rails')
    end
  end

  describe 'load_or_create' do
  end

  describe '#on_rubygems?' do

    it 'gem is found' do
    end

    it 'gem is not found' do
    end
  end

  describe 'retrieve_metadata' do
  end

  describe 'retrieve_rpm' do
  end

  describe 'retrieve_versions' do
  end

  describe 'update_from_source' do
  end

  describe 'search' do
  end

  describe 'gem_name' do
  end

  describe 'rpm?' do
  end

  describe 'version_in_fedora' do
  end

  describe 'upto_date_in_fedora' do
  end

  describe 'depencency_packages' do
  end

  describe 'dependent_packages' do
  end

  describe 'uri_for_version' do
  end

  describe 'download_version' do
  end

  describe 'download' do
  end

  describe 'description_string' do
  end

end
