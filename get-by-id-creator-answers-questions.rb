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

url_params = {
  :format => "json"
}


issue_3686_offset = 7 * 3600 # 7 hours off
csv = []  
question_number = 0
first_id = 0
ARGF.each_line do |id|
  url = "https://support.mozilla.org/api/2/question/" + id.chomp + "/"
  sleep(1.0) # sleep 1 second between API calls
  q  = getKitsuneResponse(url, url_params, logger)
  logger.ap q
  next if q.nil?
  updated = q["updated"]
  logger.debug "created from API:" + q["created"] + "<-- this is PST not UTC despite the 'Z'"
    # All times returned by the API are in PST not PDT and not UTC
    # All URL parameters for time are also in PST not UTC
    # See https://github.com/mozilla/kitsune/issues/3961 and
    # https://github.com/mozilla/kitsune/issues/3946
    # The above may change in the future if we migrate the Kitsune database to UTC
  created = Time.parse(q["created"].gsub("Z", "PST")) 
  logger.debug "created with PST correction:" + created.to_s

  if !updated.nil?
    logger.debug "updated from API:" + updated + "<-- this is PST not UTC despite the 'Z'"
    updated = Time.parse(q["updated"].gsub("Z", "PST"))
    logger.debug "updated with PST correction:" + updated.to_s
  end
    
  id = q["id"]
  logger.debug "QUESTION id:" + id.to_s
  first_id = id if first_id == 0
  question_number += 1
  logger.debug "QUESTION number:" + question_number.to_s
  tags = q["tags"]
  tag_str = ""
  tags.each { |t| tag_str = tag_str + t["slug"] + ";"   }
  answers = q["answers"]
  answers_str = ""
  answers.each { |a| answers_str = answers_str + a.to_s + ";"   }
  creator = q["creator"]["username"]
  logger.debug 'answers_str:' + answers_str
  logger.debug 'creator:' + creator

  csv.push(
    [
    id, created.to_s, q["updated"].to_s, q["title"], q["content"], 
    tag_str, q["product"], q["topic"], q["locale"],
    answers_str, creator
      ])

  logger.debug 'created:' + q["created"].to_i.to_s
  sleep(1)
end
headers = ['id', 'created', 'updated', 'title', 'content', 'tags', 'product', 'topic', 
  'locale', 'answers', 'creator']
FILENAME = sprintf("id-%s-unixtime-%s-by-id-firefox-creator-answers-desktop-all-locales.csv", 
  first_id, Time.now.to_i.to_s)
CSV.open(FILENAME, "w", write_headers: true, headers: headers) do |csv_object|
  csv.each {|row_array| csv_object << row_array }
end
