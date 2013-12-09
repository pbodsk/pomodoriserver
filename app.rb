require 'sinatra'
require 'sinatra/activerecord'
require './config/environments.rb'
require './models/session'
require 'json'

get '/' do 
  "Hello World"
end

post '/update' do
  content_type :json
  @input_data = JSON.parse(request.body.read)
  @pomodori_session = Session.new(@input_data)
  if(@pomodori_session.save)
    "saved!"
  else
    "not saved"
  end
end