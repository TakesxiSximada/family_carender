require 'sinatra'
require 'uri'
require 'net/http'
require 'json'

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

post '/watson2' do
  username = nil
  password = nil

  vcap_serivces = ENV['VCAP_SERVICES'] || open('family-calendar_VCAP_Services.json', 'r') { |f| f.read }
  credentials = JSON.parse(vcap_serivces)['speech_to_text'][0]['credentials']
  username = credentials['username']
  password = credentials['password']

  data = params['voicedata'][:tempfile].read
  content_type 'application/json'
  watson_speech_to_text(username, password, data)
end
