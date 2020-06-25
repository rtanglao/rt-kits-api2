#!/usr/bin/env ruby
require 'json'
require 'rubygems'
require "google/apis/gmail_v1"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"
require 'mime'
require 'mail'
require 'awesome_print'
require 'parseconfig'
require 'logger'
require 'csv'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG

OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
APPLICATION_NAME = "Gmail API Ruby Quickstart".freeze
CREDENTIALS_PATH = "credentials.json".freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = "token.yaml".freeze
SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_SEND # 
# https://www.googleapis.com/auth/gmail.modify #Google::Apis::GmailV1::AUTH_GMAIL_READONLY

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
  user_id = "default"
  credentials = authorizer.get_credentials user_id
  if credentials.nil?
    url = authorizer.get_authorization_url base_url: OOB_URI
    puts "Open the following URL in the browser and enter the " \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

# Initialize the API
service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

email_config = ParseConfig.new('email.conf').params
to = email_config['to_address']
previous_escalations_file_exists = File.exists? 'previous-escalations.txt'
pp previous_escalations_file_exists
previous_ids = []
if previous_escalations_file_exists
  File.readlines('previous-escalations.txt').each do |line|
    previous_ids.push(line.to_i)
  end
end
logger.ap previous_ids

escalations_for_subject = ""
no_changes = true
new_ids_to_escalate = []
ARGF.each_line do |csv_line|
  parsed_csv = CSV.parse(csv_line)
  logger.ap parsed_csv[0]
  escalate_id = parsed_csv[0][0]
  title = parsed_csv[0][3]
  logger.debug "escalate id:" + escalate_id
  logger.debug "title:" + title
  escalate_id = escalate_id.to_i
  if !previous_ids.include?(escalate_id)
    no_changes = false
    logger.debug "new id to escalate:" + escalate_id.to_s
    escalations_for_subject += " " + escalate_id.to_s.chomp + ':' + title[0..39] + ","
    new_ids_to_escalate.push("<li>escalate:" + "<a href =\"https://support.mozilla.org/questions/"+ escalate_id.to_s + "\">" + escalate_id.to_s + "</a>:" + title + "</li>") 
    previous_ids.push(escalate_id)
  end
end
logger.debug "new ids to escalate:"
logger.ap new_ids_to_escalate
logger.debug "previous ids with new ids to escalate:"
logger.debug previous_ids

body = "<ol>"
new_ids_to_escalate.each do |text|
  body += text
end
body += "</ol>"
logger.debug "escalations for subject" + escalations_for_subject
logger.debug "body" + body
body = "Time:" + Time.now.to_s + "<br /><br/>" + body

if no_changes
  logger.debug "Exiting because there were no new escalations"
  exit
end
user_id = "me"
message              = Mail.new
message.date         = Time.now
message.subject      = 'FF Desktop escalations:' + escalations_for_subject
message.body         = body
message.content_type = 'text/html'
message.from         =  user_id
message.to           = to

msg = message.encoded
message_object = Google::Apis::GmailV1::Message.new(raw:message.to_s)                 
response = service.send_user_message("me", message_object) 
ap response
# cleanup
# rename old file if it exists and if there were changes

FileUtils.mv("previous-escalations.txt", "previous-escalations.txt~") if previous_escalations_file_exists
# write out new file
File.open('previous-escalations.txt', 'w') do |file| 
  previous_ids.each do |id|
    file.print id.to_s + "\n"
  end
end