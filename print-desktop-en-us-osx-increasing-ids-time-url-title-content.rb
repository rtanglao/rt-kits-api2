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
  	el\scapitan|sierra|yosemite|mavericks|
    macbook|imac|powermac|macpro|mac\spro|macintosh)
/x
num_osx_questions  = 0
id_time_url_title_content_tags_array = []
CSV.foreach(FILENAME, :headers => true) do |row|
  hash = {}
  content = ""
  logger.debug row['tags']
  logger.debug row['title']
  next if row['locale'] != "en-US" || row['product'] != 'firefox'
  found_in_title_or_content = false
  if osx_regexp.match(row['title']) 
  	logger.debug "FOUND os x in title"
  	found_in_title_or_content = true
  end	
  
  if !found_in_title_or_content 
  	content  = Nokogiri::HTML.fragment(row['content']).text 
  	logger.debug 'CONTENT:' + content
  	if osx_regexp.match(content) 
  		logger.debug "FOUND os x in content"
  		found_in_title_or_content = true
  	end
  end
  next if !osx_regexp_tags.match(row['tags']) if !found_in_title_or_content
  num_osx_questions += 1
  # id_array.push(row['id'].to_s) if ids
  hash["url"] = "https://support.mozilla.org/questions/" + row['id'].to_s
  hash["id"] = row['id']
  hash["title"] = row['title']
  hash["content"] = content[0..79]
  hash["tags"] = row["tags"]
  # 10/2/2019 20:34:35
  hash["created"] = Time.at(row["created"].to_i).strftime("%-m/%-d/%Y %H:%M:%S")
  id_time_url_title_content_tags_array.push(hash)
end
logger.debug 'num_osx_questions:' + num_osx_questions.to_s
#awesome_print id_time_url_title_content_tags_array
#sorted_array = id_array.sort
#logger.debug sorted_array
#puts sorted_array
