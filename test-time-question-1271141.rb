#!/usr/bin/env ruby
require 'json'
require 'rubygems'
require 'typhoeus'
require 'awesome_print'
require 'time'

# This script tests: https://github.com/mozilla/kitsune/issues/3686

def getKitsuneResponse(url, params)
  result = Typhoeus::Request.get(url,
    :params => params )
  try_count = 0
  begin
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
      # raise e
      x = nil
    end
  end
  return x
end

 url_params = {
} 

url = "https://support.mozilla.org/api/2/question/1271141/"
question  = getKitsuneResponse(url, url_params)
ap question
