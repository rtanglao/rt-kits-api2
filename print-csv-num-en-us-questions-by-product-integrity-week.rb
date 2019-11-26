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

if ARGV.length < 2
  puts "usage: #{$0} [sumoquestions.csv] [datefile.txt]"   
  exit
end

CSV_FILENAME = ARGV[0]
DATE_FILENAME = ARGV[1]

puts 'product_integrity_week_start, num_ff_desktop_en_us_questions'
num_questions = 0

IO.foreach(DATE_FILENAME) do |date|
  date = date.chomp
  dstart_gte = DateTime.parse(date + "Z").to_time.to_i
  dend_lt = DateTime.parse(date + "Z").next_day(7).to_time.to_i
  num_questions  = 0
  CSV.foreach(CSV_FILENAME, :headers => true) do |row|
    # sample created time in CSV file: "2019-11-25 14:49:10 -0800"
    # time in date file: 2019-11-25
    next if row['locale'] != "en-US" || row['product'] != 'firefox'
    created = DateTime.parse(row['created']).to_time.to_i
    num_questions += 1 if created >= dstart_gte && created < dend_lt
  end
  puts( date + ', ' + num_questions.to_s)
end
logger.debug 'num_questions:' + num_questions.to_s
