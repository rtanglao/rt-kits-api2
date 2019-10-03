#!/usr/bin/env ruby
require 'json'
require 'rubygems'
require 'awesome_print'
require 'json'
require 'time'
require 'date'
require 'csv'
require 'logger'
require 'nokogiri'

# fragment = Nokogiri::HTML.fragment('<span>Chunky bacon</span>')
# fragment.text

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG

if ARGV.length < 1
  puts "usage: #{$0} [sumoquestions.csv]"   
  exit
end

FILENAME = ARGV[0]
osx_regexp_tags = 
/
  (?:os-x|mojave|catalina|macos|elcapitan|osx|mac-os|\
  	el-capitan|sierra|yosemite|mavericks)
/x
osx_regexp= 
/
  (os\sx|mojave|catalina|macos|elcapitan|osx|mac\sos|
  	el\scapitan|sierra|yosemite|mavericks)
/x
num_osx_questions  = 0
id_time_url_title_content_array = []
CSV.foreach(FILENAME, :headers => true) do |row|
  hash = {}
  logger.debug row['tags']
  logger.debug row['title']
  next if row['locale'] != "en-US" || row['product'] != 'firefox'
  found_in_title_or_content = false
  if osx_regexp.match(row['title']) 
  	logger.debug "found os x in title"
  	found_in_title_or_content = true
  end			
  next if !osx_regexp_tags.match(row['tags']) if !found_in_title_or_content
  num_osx_questions += 1
  # id_array.push(row['id'].to_s) if ids
  # id_array.push("* https://support.mozilla.org/questions/" + row['id'].to_s) if markdown
end
logger.debug 'num_osx_questions:' + num_osx_questions.to_s
#sorted_array = id_array.sort
#logger.debug sorted_array
#puts sorted_array
