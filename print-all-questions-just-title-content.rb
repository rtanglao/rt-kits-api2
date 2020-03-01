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

title_content_array = []
CSV.foreach(FILENAME, :headers => true) do |row|
  hash = {}
  content = ""
  logger.debug row['title']  
  content  = Nokogiri::HTML.fragment(row['content']).text 
  logger.debug 'CONTENT:' + content
  #content = content[0..279] + "..." if content.length > 279

  title_content_array.push(
    [
      row['title'],
      content,
    ])
end

headers = ['title', 'content']

OUT_FILENAME = sprintf("title-parsed-content-%s", ARGV[0])
CSV.open(OUT_FILENAME, "w", write_headers: true, headers: headers) {|csv_object|
    title_content_array.each {|row_array| csv_object << row_array }}
