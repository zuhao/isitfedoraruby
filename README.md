[![Build Status](https://travis-ci.org/axilleas/isitfedoraruby.png)](https://travis-ci.org/axilleas/isitfedoraruby)
[![Code Climate](https://codeclimate.com/github/axilleas/isitfedoraruby.png)](https://codeclimate.com/github/axilleas/isitfedoraruby)
[![Coverage Status](https://coveralls.io/repos/axilleas/isitfedoraruby/badge.png?branch=master)](https://coveralls.io/r/axilleas/isitfedoraruby)
[![Dependency Status](https://gemnasium.com/axilleas/isitfedoraruby.png)](https://gemnasium.com/axilleas/isitfedoraruby)


IsItFedoraRuby is a web-application for keeping track of the Fedora/Ruby
integration, especially `gem -> rpm` conversion.

## Installation

First, make sure you have ruby 2.0+ installed.

Clone the repository:

```bash
git clone https://github.com/axilleas/isitfedoraruby.git
```

Install gems:

```bash
bundle install
```

Run the migrations:

```bash
rake db:migrate
```

Finally, run the following rake task to populate the database:
```ruby
rake fedora:rpm:import:all
```

Please take note that the importing process can take a long time, depending
on your network connection as well as the server load. Try to use batch mode
to import and set reasonably small batch numbers, in order to lessen the
burden to the servers.

## Updating

If you already have gems and/or rpms imported, and only want to update them,
run the following commands:

```bash
# Update gems whose last update time was earlier than 7 days ago.
rake "fedora:rpm:update:rpms[7]"

# Update rpms whose last update time was earlier than 7 days ago.
rake "fedora:gem:update:gems[7]"
```

## Rake tasks

You can see what tasks are currently supported with the following command:

```
rake -T | grep fedora

rake fedora:gem:import:all_names               # FEDORA | Import a list of names of ALL gems from rubygems.org
rake fedora:gem:import:metadata[number,delay]  # FEDORA | Import gems metadata from rubygems.org
rake fedora:gem:update:gems[age]               # FEDORA | Update gems metadata from rubygems.org
rake fedora:rawhide:create                     # FEDORA | Create file containing Fedora rawhide(development) version
rake fedora:rawhide:version                    # FEDORA | Get Fedora rawhide(development) version
rake fedora:rpm:import:all[number,delay]       # FEDORA | Import ALL rpm metadata (time consuming)
rake fedora:rpm:import:bugs[rpm_name]          # FEDORA | Import bugs of a given rubygem package
rake fedora:rpm:import:commits[rpm_name]       # FEDORA | Import commits of a given rubygem package
rake fedora:rpm:import:deps[rpm_name]          # FEDORA | Import depedencies of a given rubygem package
rake fedora:rpm:import:gem[rpm_name]           # FEDORA | Import respective gem of a given rubygem package
rake fedora:rpm:import:koji_builds[rpm_name]   # FEDORA | Import koji builds of a given rubygem package
rake fedora:rpm:import:names                   # FEDORA | Import a list of names of all rubygems from apps.fedoraproject.org
rake fedora:rpm:update:oldest_rpms[number]     # FEDORA | Update oldest n rpms
rake fedora:rpm:update:rpms[age]               # FEDORA | Update rpms metadata
```

## Contribute

Feel free to contribute any code or ideas to make it better.
