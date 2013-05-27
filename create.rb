#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'nokogiri'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

env = proc { |k| ENV[k] || raise("Missing env '#{k}'") }

opts = {
  url: env.call('AODB_HOST'),
  user: env.call('AODB_USER'),
  pass: env.call('AODB_PASS'),
  target: env.call('AODB_TARGET')
}

base_url = "https://#{opts[:url]}"

bot = Mechanize.new do |conf|
  conf.user_agent_alias = 'Mechanize'
end

page = bot.get("#{base_url}/login")

page.form_with(:id => 'form-crowd-login') do |f|
  f.username = opts[:user]
  f.password = opts[:pass]
end.click_button

prefix = case opts[:target]
when 'JIRA'
  'rest'
when 'Confluence'
  'wiki/rest'
else
  raise "Unknown target '#{opts[:target]}'"
end

headers = { 'X-Requested-With' => 'XMLHttpRequest', 'Content-Type' => 'application/json; charset=utf-8', 'Accept' => 'application/json, text/javascript, */*'}

begin
  page = bot.post("#{base_url}/#{prefix}/obm/1.0/runbackup", '{"cbAttachments":"true"}', headers)
rescue Mechanize::ResponseCodeError => ex
  STDERR.puts ex.page.body
  exit 1
end

puts 'Done'
puts page.body