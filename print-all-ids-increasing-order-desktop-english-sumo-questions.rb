#!/usr/bin/env ruby
require 'json'
require 'rubygems'
require 'awesome_print'
require 'json'
require 'time'
require 'date'
require 'csv'
require 'logger'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG

if ARGV.length < 2
  puts "usage: #{$0} [sumoquestions.csv] [markdown|ids]"  
  exit
end

markdown = ARGV[1] == "markdown" ? true : false
ids = ARGV[1] == "ids" ? true : false
exit if !markdown && !ids

FILENAME = ARGV[0]

id_array = []
CSV.foreach(FILENAME, :headers => true) do |row|
  next if row['locale'] != "en-US" || row['product'] != 'firefox'
  id_array.push(row['id'].to_s) if ids
  id_array.push("* https://support.mozilla.org/questions/" + row['id'].to_s) if markdown
end
sorted_array = id_array.sort
logger.debug sorted_array
puts sorted_array
