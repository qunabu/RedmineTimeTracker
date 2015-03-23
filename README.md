# RedmineTimeTracker
Simple standalone Redmine Time Tracker.

# Why?
Redmine has own sophistictated time tracking system, so why inveting wheel again ?
My project was to simplify this as much as possible, the idea is that there is one
status for project, let's call it "**In Progress**" which means that currently somebody
is working on some task. That's all.

RedmineTimeTracker is counting time when "**In Progress**" was set and it groups the results
by users project and time period.

Limitation is that one person should have only one issue set to "**In Progress**". 

# Requiremnts 

 - Redmine with REST API enabled
 - username and password with access to issues 

# Installation

 1. clone repository
 2. get dependencies with [composer](https://getcomposer.org/) `composer update`
 3. get dependencies with [bower](http://bower.io/) `bower update`
 4. change filename **php/RedmineTimeTrackerConfig.sample.php** to **php/RedmineTimeTrackerConfig.php**
 5. set valid data in config file