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

if ARGV.length < 1
	puts "usage: #{$0} [sumoquestions.csv]"  
  exit
end

FILENAME = ARGV[0]

CSV.foreach(FILENAME, :headers => true) do |row|
	  puts row['id'] 
end

