#!/usr/bin/env ruby
require 'json'
require 'rubygems'
require 'awesome_print'
require 'json'
require 'time'
require 'date'
require 'csv'
require 'logger'
require 'typhoeus'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG

def getKitsuneResponse(url, params, logger)
  logger.debug url
  logger.debug params
  try_count = 0
  begin
    result = Typhoeus::Request.get(
        url,
        :params => params )
    x = JSON.parse(result.body)
  rescue JSON::ParserError => e
    try_count += 1
    if try_count < 4
      $stderr.printf("JSON::ParserError exception, retry:%d\n",\
                     try_count)
      sleep(10)
      retry
    else
      $stderr.printf("JSON::ParserError exception, retrying FAILED\n")
      x = nil
    end
  end
  return x
end

if ARGV.length < 1
  puts "usage: #{$0} [sumoquestions.csv]"   
  exit
end

FILENAME = ARGV[0]

CSV.foreach(FILENAME, :headers => true) do |row|
  logger.debug row.ai
  answers_str = row["answers"] 
  answers = []
  answers_str.split(";").each {|a| answers.push a.to_i} 
  creator = row["creator"]
  id = row["id"]
  logger.debug  answers.ai
  url = "https://support.mozilla.org/api/2/answer/"

  url_params = {
    :format => "json",
    :question => id 
  } 
  next if answers.empty?
  answers_array  = getKitsuneResponse(url, url_params, logger) 
  logger.debug answers_array.ai
  answers_array["results"].each do |answer|
    logger.debug answer
    logger.debug answer["creator"]
    answer_username = answer["creator"]["username"]
    puts (answer_username) if answer_username != creator
  end
end