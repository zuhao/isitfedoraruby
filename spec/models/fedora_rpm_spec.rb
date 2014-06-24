# == Schema Information
#
# Table name: fedora_rpms
#
#  id                  :integer          not null, primary key
#  name                :string(255)      not null
#  source_uri          :string(255)
#  last_commit_message :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  author              :string(255)
#  last_committer      :string(255)
#  last_commit_date    :datetime
#  last_commit_sha     :string(255)
#  homepage            :string(255)
#  ruby_gem_id         :integer
#  commits             :integer
#  fedora_user         :string(255)
#  summary             :text(255)
#  description         :text(255)
#

require 'rails_helper'

describe FedoraRpm do

  xit 'to_param' do
  end

  xit 'shortname' do
  end

  xit 'versions' do
  end

  xit 'version_for' do
  end

  xit 'up_to_date?' do
  end

  xit 'patched?' do
  end

  xit 'json_dependencies' do
  end

  xit 'json_dependents' do
  end

  xit 'base_uri' do
  end

  xit 'retrieve_commits' do
  end

  xit 'retrieve_specs' do
  end

  xit 'retrieve_versions' do
  end

  xit 'retrieve_maintainer' do
  end

  xit 'retrieve_hoempage' do
  end

  xit 'retrieve_dependencies' do
  end

  xit 'version_valid?' do
  end

  xit 'retrieve_gem' do
  end

  xit 'retrieve_bugs' do
  end

  xit 'retrieve_builds' do
  end

  xit 'update_commits' do
  end

  xit 'update_specs' do
  end

  xit 'update_gem' do
  end

  xit 'update_bugs' do
  end

  xit 'update_builds' do
  end

  xit 'update_from_source' do
  end

  xit 'rpm_name' do
  end

  xit 'search' do
  end

  xit 'dependency_packages' do
  end

  xit 'dependent_packages' do
  end

  xit 'obfuscated_fedora_user' do
  end

  xit 'last_commit_date_in_words' do
  end

  xit ' maintainer' do
  end

end
