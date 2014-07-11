# == Schema Information
#
# Table name: rubygem_rpms
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

  let!(:rpm) { create(:rubygem_foo) }

  it { should validate_uniqueness_of :name }
  it { should validate_presence_of :name }

  it 'is invalid without a name' do
    rpm.name = nil
    expect(rpm).to be_invalid
  end

  it 'must have at least one koji build' do
  end

  describe 'source files of rubygem-foo' do
    it 'base uri points to pkgs.fp.o gitweb' do
      expect(rpm.base_uri).to eq 'http://pkgs.fedoraproject.org/cgit/'
    end

    it 'has proper source uri' do
      base_uri = 'http://pkgs.fedoraproject.org/cgit/'
      expect(rpm.source_uri).to eq "#{base_uri}#{rpm.name}.git"
    end
  end

  describe '#to_param' do
    it 'returns the name stored in db' do
      expect(rpm.name).to eq 'rubygem-foo'
    end
  end

  describe '#shortname' do
    it 'returns foo if rpm name is rubygem-foo' do
      shortname = rpm.name.gsub(/rubygem-/, '')
      expect(shortname).to eq 'foo'
    end
  end

  describe '#rawhide_version' do
    it 'returns the latest fedora version as a number' do
      page = Nokogiri.HTML(open(Rails.root + \
                                'spec/support/fedora_rawhide.html'))
      expect(page.text.match(/\d{2}/)[0].to_i).to eq 21
    end
  end

  describe '#retrieve_builds' do
    it 'returns the koji builds of supported Fedora versions' do
    end
  end

  describe '#fedora_versions' do

    context 'support latest 3 Fedora versions' do

      it 'has exactly 3 keys' do
        expect(FedoraRpm.fedora_versions.keys.count).to eq(3)
      end
    end
  end # FedoraRpm#fedora_versions

  describe '#fas_name' do
    it "returns the owner's FAS name" do
    end
  end
end # FedoraRpm
