#!/usr/bin/env ruby
if ARGV.length < 6
    puts "usage: #{$0} yyyy mm dd end-yyyy mm id" 
    exit
end
../get-creator-answers-questions-for-arbitrary-time-period.rb ARGV[0] ARGV[1] ARGV[2] ARGV[3] ARGV[4] ARGV[5] 
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb 2019-09-01-2019-09-07-firefox-creator-answers-desktop-all-locales.csv markdown  