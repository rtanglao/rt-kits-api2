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
output_row_array = []
CSV.foreach(FILENAME, :headers => true) do |row|
  logger.debug row.ai
  answers_str = row["answers"] 
  answers = []
  answers_str.split(";").each {|a| answers.push a.to_i} 
  creator = row["creator"]
  id = row["id"]
  row["synthetic_answers"] = ""
  logger.debug  answers.ai
  url = "https://support.mozilla.org/api/2/answer/"

  url_params = {
    :format => "json",
    :question => id 
  } 
  if !answers.empty?
    answers_array  = getKitsuneResponse(url, url_params, logger) 
    logger.debug answers_array.ai
    answers_array["results"].each do |answer|
      logger.debug answer.ai
      row["synthetic_answers"] = row["synthetic_answers"] + " " if row["synthetic_answers"] != ""
      id =  answer["id"]
      content = answer["content"].tr("\n"," ")
      creator = answer["creator"]["username"]
      updated_by = ""
      updated_by = answer["updated_by"]["username"] if !answer["updated_by"].nil?
      answer_created = Time.parse(answer["created"].gsub("Z", "PST")) #issue 3686 time is in PST not UTC
      logger.debug "answer created with PST correction:" + answer_created.to_s
      answer_updated = Time.parse(answer["updated"].gsub("Z", "PST")) #issue 3686 time is in PST not UTC
      logger.debug "answer updated with PST correction:" + answer_updated.to_s
      row["synthetic_answers"] = row["synthetic_answers"] + 
        "id:" +  id.to_s + 
        ",created:" + answer_created.to_s +
         ",updated:" + answer_updated.to_s + 
         ",creator:" + creator + 
        ",updated_by:" + updated_by +
        ",is_spam:" + answer["is_spam"].to_s +
        ",num_helpful_votes:" + answer["num_helpful_votes"].to_s +
        ",num_unhelpful_votes:" + answer["num_unhelpful_votes"].to_s +
        ",content:" + content
    end
  end
  output_row_array.push(row)
  sleep(1) # wait 1 second before next API call
end
headers = ['id', 'created', 'updated', 'title', 'content', 'tags', 'product', 'topic', 
  'locale', 'answers', 'creator', 'synthetic_answers']
OUTPUT_FILENAME = sprintf("with-flattened-answers-%s.csv", FILENAME.rpartition('.').first)
CSV.open(OUTPUT_FILENAME, "w", write_headers: true, headers: headers) do |csv_object|
  output_row_array.each {|row_array| csv_object << row_array }
end

