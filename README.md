# RedmineTimeTracker
Simple standalone PHP Redmine Time Tracker.

# Why?
Redmine has own sophisticated time tracking system, so why re-inventing wheel again ?
My project was to simplify this as much as possible, the idea is that there is one
status for project, let's call it "**In Progress**" which means that currently somebody
is working on some task. That's all.

RedmineTimeTracker is counting time when "**In Progress**" was set and it groups the results
by users, projects and time periods.

Limitation is that one person should have only one issue set to "**In Progress**" and this status should not be left to "**In Progress**"
during nonworking hours.

# Why PHP ?
I would have written this as Redmine Plugin, yet don't know anything about Ruby.

# Requiremnts 

 - Redmine with REST API enabled
 - username and password with access to issues 

# Installation

 1. clone repository
 2. get dependencies with [composer](https://getcomposer.org/) `composer update`
 3. get dependencies with [bower](http://bower.io/) `bower update`
 4. change filename **php/RedmineTimeTrackerConfig.sample.php** to **php/RedmineTimeTrackerConfig.php**
 5. set valid data in config file

# Dependencies 

 - bootstrap
 - smarty
 - jquery

# Screenshot
![Screenshot](https://raw.githubusercontent.com/qunabu/RedmineTimeTracker/master/app1.png)