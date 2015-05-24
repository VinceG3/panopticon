Steps to add new watch host
===========================

Install thor, dante, pry on the new target with `gem install`
Add new host and service to `Panopticonfile` and `config/deploy/production.rb`
Deploy
Go to project directory on new target and run `bin/panopticon console`
Make sure there's no errors
Run `bin/panopticon daemonize`
add cron job to start the server
    @reboot ( cd /home/deploy/panopticon/current && bin/panopticon daemonize )
reboot machine

TODO
====

Find out best way to get project to start on boot.