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
      
url_params = {
  :format => "json",
  :product => "firefox", 
  #:created => created_str,
  :created__gt => '2018-5-28',
  :created__lt => '2018-5-30',
  :ordering => "+created",
} 

url = "https://support.mozilla.org/api/2/question/"
end_program = false
question_number = 0
  
while !end_program
  sleep(1.0) # sleep 1 second between API calls
  questions  = getKitsuneResponse(url, url_params, logger)
  logger.debug questions.ai
  questions2 = questions["results"].to_a
  created_1st = Time.parse(questions2[0]["created"]).to_i
  logger.debug created_1st.to_s
  exit
  url = questions["next"]
  logger.debug "next url:" + url
  url_params = nil
  questions["results"].each do|question|
    updated = question["updated"]
    logger.debug "updated:" + updated
    if !updated.nil?
      updated = Time.parse(question["updated"])
      logger.debug "QUESTION updated:" + updated.to_i.to_s
      question["updated"] = updated
    end
    logger.debug "created:" + question["created"]
    created = Time.parse(question["created"])
    logger.debug "QUESTION created:" + created.to_i.to_s
    question["created"] = created
    if created < MIN_DATE
      end_program = true
      break
    end
    id = question["id"]
    logger.debug "QUESTION id:" + id.to_s
    question_number += 1
    logger.debug "QUESTION number:" + question_number.to_s
    result_array = questionsColl.find({ 'id' => id }).update_one(question, :upsert => true ).to_a
    nModified = 0
    result_array.each do |item|
      nModified = item["nModified"] if item.include?("nModified") 
      break
    end
    if nModified == 0
      logger.debug "INSERTED^^"
    else
      logger.debug "UPDATED^^^^^^"
    end
  end 
end
