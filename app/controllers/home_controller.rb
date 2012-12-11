class HomeController < ApplicationController
  def show
    #Text to localize    
    @page_title = _('Welcome')
    @page_app_name = _('Is It Fedora Ruby')
    @page_description = _('This is the homepage for the isitfedoraruby web application.')
    @page_compare_gems = _('New: compare your gem file against Fedora!')
    
    @page_most_popular_gems = _('Most popular gems')
    @page_gem = _('Gem')
    @page_version = _('Version')
    @page_rpm_version = _('RPM Version')
    @page_downloads = _('Downloads')
    
    @page_most_popular_rpms = _('Most popular RPMs')
    @page_upstream = _('Upstream')
    @page_rawhide = _('Rawhide')
    @page_git_commits = _('Git commits')
    
    @page_most_recent_rpms = _('Most recent RPMs')
    @page_rpm = _('RPM')
    @page_commits = _('Commits')
    @page_updated = _('Updated')
    
    @page_most_wanted_gems = _('Most wanted gems')
    @page_wanted_by = _('Wanted by')
    
    
    @popular_gems = RubyGem.most_popular.limit(10)
    @popular_rpms = FedoraRpm.most_popular.limit(10)
    @wanted_gems = RubyGem.most_wanted.limit(10)
    @recent_rpms = FedoraRpm.most_recent.limit(10)
  end
end
