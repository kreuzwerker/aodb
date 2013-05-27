# Atlassian OnDemand backup

[Atlassian OnDemand](http://www.atlassian.com/de/software/ondemand/overview) does not offer an API for doing backups. This project provides two small scripts to a) assist with creating (using Ruby and the mechanize gem) and b) downloading (using curl and some retry-logic take from [here](https://jira.atlassian.com/browse/AOD-5975)).

These scripts are intended to be executed using cron.

## Installation

* Requires curl and Ruby 1.9 (and the `bundler` gem), optionally managed using RVM (a Ruby with the alias `1.9` must be installed)
* `bundle install`

## Configuration

Both scripts rely on environment variables for configuration:

* `AODB_HOST`: the fully-qualified domain name for the instance (e.g. `foobar.atlassian.net`)
* `AODB_USER`: the username (requires administrator privileges)
* `AODB_PASS`: the password
* `AODB_TARGET` one of `JIRA` or `Confluence`

You might want to put those exports into a file which you source before running either `create.rb` or `download.sh`.

## Running

* `AODB_TARGET=JIRA ./create.rb` - create a JIRA backup for the instance specified in `AODB_HOST`. The script will return immediately - before downloading you should wait for a couple of minutes before downloading (the exact amount of time depends on the size of your backup).
* `AODB_TARGET=JIRA ./download.rb` - download the JIRA backup via WebDAV.