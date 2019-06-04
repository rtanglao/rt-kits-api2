#!/usr/bin/env ruby
require 'json'
require 'rubygems'
require 'typhoeus'
require 'awesome_print'
require 'json'
require 'time'
require 'date'
require 'csv'
require 'logger'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG

def getKitsuneResponse(url, params, logger)
  logger.debug url
  logger.debug params
  try_count = 0
  begin
    result = Typhoeus::Request.get(url,
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


if ARGV.length < 3
  puts "usage: #{$0} yyyy mm dd" 
  exit
end

created_str = ARGV[0] + "-" + ARGV[1] + "-" + ARGV[2]
# because of issue 3686, https://github.com/mozilla/kitsune/issues/3686, 
# go back one day and forward one day
created_time = DateTime.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i)
created_time_minus_1day = created_time - 1
greater_than = created_time_minus_1day.strftime("%Y-%-m-%-e")
MIN_DATE = created_time_minus_1day.to_time.to_i
created_time_plus_1day = created_time + 1
less_than = created_time_plus_1day.strftime("%Y-%-m-%-e")

logger.debug "greater than:" + greater_than
logger.debug "less than:" + less_than

url_params = {
  :format => "json",
  :product => "firefox", 
  #:created => created_str,
  :created__gt => greater_than,
  :created__lt => less_than,
  :ordering => "+created",
} 

url = "https://support.mozilla.org/api/2/question/"
end_program = false
question_number = 0
issue_3686_offset = 7 * 3600 # 7 hours off
  
while !end_program
  sleep(1.0) # sleep 1 second between API calls
  questions  = getKitsuneResponse(url, url_params, logger)
  url = questions["next"]
  logger.debug "next url:" + url
  url_params = nil
  questions["results"].each do|question|
    updated = question["updated"]
    created = Time.parse(question["created"])
    logger.debug "QUESTION created w/error:" + created.to_i.to_s
    question["created"] = created.to_i + issue_3686_offset
    logger.debug "Question created w/error fixed:" + question["created"].to_s
    logger.debug "updated:" + updated
    if !updated.nil?
      updated = Time.parse(question["updated"])
      logger.debug "QUESTION updated w/error:" + updated.to_i.to_s
      question["updated"] = updated.to_i + issue_3686_offset
      logger.debug "Question updated w/error fixed:" + question["updated"].to_s
    end
    id = question["id"]
    logger.debug "QUESTION id:" + id.to_s
    question_number += 1
    logger.debug "QUESTION number:" + question_number.to_s
    if question["created"] < MIN_DATE || url.nil?
      end_program = true
      break
    end
  end 
end
