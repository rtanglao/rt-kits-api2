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
  puts "usage: #{$0} [sumoquestions.csv] csv|markdown|markdown25"   
  exit
end

FILENAME = ARGV[0]

csv = false
markdown = false
markdown25 = false

if ARGV[1] == "csv"
  csv = true
elsif ARGV[1] == "markdown"
  markdown = true
elsif ARGV[1] == "markdown25"
  markdown = true
  markdown25 = true
else
  puts "usage: #{$0} [sumoquestions.csv] csv|markdown|markdown25"
  exit
end

num_questions  = 0
id_time_url_title_content_tags_array = []
CSV.foreach(FILENAME, :headers => true) do |row|
  hash = {}
  content = ""
  logger.debug row['tags']
  logger.debug row['title']
  locale = row['locale']
  product = row['product']
  next if locale != "en-US" || product != 'firefox'
  
  content  = Nokogiri::HTML.fragment(row['content']).text 
  logger.debug 'CONTENT:' + content
  content = content[0..279] + "..." if content.length > 279 if markdown
  content = content[0..1023] + "..." if content.length > 1023 if csv

  num_questions += 1

  id_time_url_title_content_tags_array.push(
    [
      row['id'].to_i,
      #Time.at(row["created"].to_i).strftime("%-m/%-d/%Y %H:%M:%S"), # 10/2/2019 20:34:35
      row["created"],
      "https://support.mozilla.org/questions/" + row['id'].to_s,
      row['title'][0..79],
      content.tr("\n"," "),
      row["tags"],
      product,
      locale
    ])
end
logger.debug 'num_questions:' + num_questions.to_s
sorted_array =  id_time_url_title_content_tags_array.sort_by { |h| h[0] }
if markdown25
  sorted_array = sorted_array.shuffle
  twenty_five_percent_index = (sorted_array.length * 0.25).round.to_i
  sorted_array = sorted_array[0..twenty_five_percent_index]
end
headers = ['id', 'created', 'url', 'title', 'content', 'tags','product', 'locale']

if csv
  output_filename = sprintf("sorted-all-desktop-en-us-%s", ARGV[0])
  CSV.open(output_filename, "w", write_headers: true, headers: headers) {|csv_object|
    sorted_array.each {|row_array| csv_object << row_array }}
  elsif markdown
    if markdown25
      output_filename= sprintf("25-percent-random-all-desktop-en-us-%s", ARGV[0]).gsub(".csv", ".md")
    else 
      output_filename = sprintf("sorted-all-desktop-en-us-%s", ARGV[0]).gsub(".csv", ".md")
    end
    logger.debug 'markdown filename:' + output_filename
    open(output_filename, 'w') do |f|
      f.puts "Number of questions:" + sorted_array.length.to_s + "\n\n"
      f.puts "| id:created | Title | Content | Tags | Notes | "
      f.puts "| --- | --- | --- | --- | --- |"
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
        slice_str = row_array[4].tr("\n","")[80..-1]
        if slice_str.nil?
          f.puts(
            sprintf("| [%d](%s)<br>%s | %s | %s | %s| |\n", 
            row_array[0], row_array[2],
            row_array[1], row_array[3].tr("\n","")[0..79],row_array[4].tr("\n","")[0..79], 
          tags_markdown))
        else
          f.puts(
          sprintf("| [%d](%s)<br>%s | %s |<details><summary>%s</summary>%s</details> | %s|\n", 
            row_array[0], row_array[2],
            row_array[1], row_array[3].tr("\n","")[0..79],row_array[4].tr("\n","")[0..79],
            slice_str, 
          tags_markdown))
        end
      end
    end
  end