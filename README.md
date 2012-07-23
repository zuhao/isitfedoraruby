Welcome to IsItFedoraRuby
=====

IsItFedoraRuby is a web-application for keeping track of the Fedora/Ruby intergration, especially gem->rpm conversion, documentation, and success stories.

This started as a Google Summer of Code 2012 project.

Installation
----

In order to install this web app, you can clone the repo from github, and run `rails server` to run it locally.

Before you run the web app, make sure you have both RubyGem and FedoraRpm info imported into the database. To do so, please run the following command.

`rake database:import_gems[refresh_list]` to import RubyGem list (gem names only).

`rake database:import_gems[all]` to import all gems in one go (not recommended).

`rake database:import_gems[batch, 50, 10]` to import gems in batches, 50 per match, 10 seconds delay.

`rake database:import_rpms` to import FedoraRpm info.

Please take note that the importing process can take a long time, depending on your network connection.

Please Contribute!
----

As this project is still in its early stage, please feel free to contribute any code or ideas to make it better.