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

if ARGV.length < 2
  puts "usage: #{$0} [sumoquestions.csv] csv|markdown"   
  exit
end

FILENAME = ARGV[0]

csv = false
markdown = false
if ARGV[1] == "csv"
  csv = true
elsif ARGV[1] == "markdown"
  markdown = true
else
  puts "usage: #{$0} [sumoquestions.csv] csv|markdown"
  exit
end

num_questions  = 0
id_time_url_title_content_tags_array = []
CSV.foreach(FILENAME, :headers => true) do |row|
  hash = {}
  content = ""
  logger.debug row['tags']
  logger.debug row['title']
  next if row['locale'] != "en-US" || row['product'] != 'firefox'
  
  content  = Nokogiri::HTML.fragment(row['content']).text 
  logger.debug 'CONTENT:' + content
  content = content[0..279] + "..." if content.length > 279

  num_questions += 1

  id_time_url_title_content_tags_array.push(
    [
      row['id'].to_i,
      #Time.at(row["created"].to_i).strftime("%-m/%-d/%Y %H:%M:%S"), # 10/2/2019 20:34:35
      row["created"],
      "https://support.mozilla.org/questions/" + row['id'].to_s,
      row['title'][0..79],
      content,
      row["tags"]
    ])
end
logger.debug 'num_questions:' + num_questions.to_s
sorted_array =  id_time_url_title_content_tags_array.sort_by { |h| h[0] }
headers = ['id', 'created', 'url', 'title', 'content', 'tags']

if csv
  FILENAME = sprintf("sorted-all-desktop-en-us-%s", ARGV[0])
  CSV.open(FILENAME, "w", write_headers: true, headers: headers) {|csv_object|
    sorted_array.each {|row_array| csv_object << row_array }}
  elsif markdown
    FILENAME = sprintf("sorted-all-desktop-en-us-%s", ARGV[0]).gsub(".csv", ".md")
    logger.debug 'markdown filename:' + FILENAME
    open(FILENAME, 'w') do |f|
      f.puts "Number of questions:" + sorted_array.length.to_s + "\n\n"
      f.puts "id | created | Title | Content | Tags"
      f.puts "--- | --- | --- | --- | ---"
      sorted_array.each do |row_array|
        tags_array = row_array[5].split(';')
        logger.debug "tags_array" + tags_array.to_s
        tags_markdown = ""
        tags_array.each do |t| 
          logger.debug t
          tags_markdown += "[" + t + "]" +
          "(https://support.mozilla.org/en-US/questions/firefox?tagged="+ t + ")" + ";"
        end  
        tags_markdown = ";" if tags_markdown == ""
        f.puts(
          sprintf("%d |[%s](%s) |%s |%s |<details><summary>%s</summary>%s</details>\n", row_array[0], row_array[1],
          row_array[2], row_array[3].tr("\n",""), 
          row_array[4].tr("\n","")[0..79], row_array[4].tr("\n",""), 
          tags_markdown))
      end
    end
  end