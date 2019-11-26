#!/usr/bin/env ruby
require 'json'
require 'rubygems'
require 'awesome_print'
require 'json'
require 'time'
require 'date'
require 'logger'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG
sunday = "2018-12-30"
(52 * 3).times do
  puts sunday
  next_sunday =  DateTime.parse(sunday).next_day(7)
  sunday = next_sunday.strftime("%Y-%m-%d")
end