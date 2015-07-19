# coding: utf-8
require 'sinatra'
require 'uri'
require 'net/http'
require 'json'

@@global_message = 'こんにちは'

def watson_speech_to_text(username, password, data)
  response = nil
  url = 'https://stream.watsonplatform.net/speech-to-text/api/v1/recognize?model=ja-JP_BroadbandModel'

  uri = URI.parse(url)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  # https.set_debug_output $stderr
  request = Net::HTTP::Post.new(url)
  request.basic_auth(username, password)
  request["Content-Type"] = "audio/wav"
  request["Transfer-Encoding"] = "chunked"

  request.body = data
  res = https.request(request)
  res.body
end

get '/' do
  open('public/index.html', 'r') { |f| f.read }
end

get '/watson' do
  username = nil
  password = nil

  vcap_serivces = ENV['VCAP_SERVICES'] || open('family-calendar_VCAP_Services.json', 'r') { |f| f.read }
  credentials = JSON.parse(vcap_serivces)['speech_to_text'][0]['credentials']
  username = credentials['username']
  password = credentials['password']

  file = '0001.wav'
  data = open(file, 'rb') { |f| f.read }
  watson_speech_to_text(username, password, data)
end

post '/watson1' do
  username = nil
  password = nil
  vcap_serivces = ENV['VCAP_SERVICES'] || open('family-calendar_VCAP_Services.json', 'r') { |f| f.read }
  credentials = JSON.parse(vcap_serivces)['speech_to_text'][0]['credentials']
  username = credentials['username']
  password = credentials['password']

  data = params['voicedata'][:tempfile].read
  content_type 'application/json'
  res = watson_speech_to_text(username, password, data)
  @@global_message = JSON.parse(res)['results'][0]['alternatives'][0]['transcript']
  res
end

post '/watson2' do
  username = nil
  password = nil
  vcap_serivces = ENV['VCAP_SERVICES'] || open('family-calendar_VCAP_Services.json', 'r') { |f| f.read }
  credentials = JSON.parse(vcap_serivces)['speech_to_text'][0]['credentials']
  username = credentials['username']
  password = credentials['password']

  data = @env['rack.input'].read
  content_type 'application/json'
  res = watson_speech_to_text(username, password, data)
  m = JSON.parse(res)['results'][0]['alternatives'][0]['transcript']
  @@global_message = m.strip
  res
end

get '/watson3' do
  message = @@global_message
  command = if message =~ /おはよう|こんにちは|こんばんは/
              'greeting'
            elsif message =~ /カレンダー/
              'calendar'
            end

  content_type 'application/json'
  { user: 123, message: message, command: command }.to_json
end

