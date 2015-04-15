Steps to add new watch host
===========================

Install god, thor on the new target with `gem install`
Add new host and service to Panopticonfile
Deploy
Go to project directory on new target and run `bin/panopticon console`
Make sure there's no errors
Run `bin/panopticon daemonize`

TODO
====

Find out best way to get project to start on boot.