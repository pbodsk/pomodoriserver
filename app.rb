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
  username = @input_data['username']
  group = @input_data['group']
  session = Session.find_by username: username, group: group
  if(session)
    session.remainingtime = @input_data['remainingtime']
    session.touch
  else
    session = Session.new(@input_data)
  end
  save_session(session)
end

private
def save_session(session)
  session.save
  generate_return_json(session)
end

def generate_return_json(session)
  Session.where(updated_at: 2.minutes.ago, group: session.group).destroy_all
  sessions = Session.find_by group: session.group
  sessions.to_json  
end