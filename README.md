# Welcome to IsItFedoraRuby #

IsItFedoraRuby is a web-application for keeping track of the Fedora/Ruby intergration, especially gem->rpm conversion, documentation, and success stories.

This started as a Google Summer of Code 2012 project.

## Installation ##

In order to install this web app, you can clone the repo from github, and run `rails server` to run it locally.

Before you run the web app, make sure you have both RubyGem and FedoraRpm info imported into the database. To do so, please run the following command.

### Step 1 ###

Make sure you import the full lists of gems and rpms first, by running the following commands.

`rake database:import_gems[refresh_list]` to import RubyGem list (without metadata).

`rake database:import_rpms[refresh_list]` to import Fedora Rpm list (without metadata).

### Step 2 ###

Import gems and rpms in batches (recommended).

`rake database:import_gems[batch, 50, 10]` to import gems in batches, 50 per batch, 10 seconds delay.

`rake database:import_rpms[batch, 50, 10]` to import rpms in batches, 50 per batch, 10 seconds delay.

Or, import them in one go (not recommended).

`rake database:import_gems[all]` to import all gems.

`rake database:import_rpms[all]` to import all rpms.

Please take note that the importing process can take a long time, depending on your network connection as well as the server load. Try to use batch mode to import and set reasonably small batch numbers, in order to lessen the burden to the servers.

### Step 3 ###

If you already have gems and/or rpms imported, and only want to update them, run the following commands.

`rake database:update_gems[7]` to update gems whose last update time was earlier than 7 days ago.

`rake database:update_rpms[7]` to update rpms whose last update time was earlier than 7 days ago.

## Please Contribute! ##

As this project is still in its early stage, please feel free to contribute any code or ideas to make it better.