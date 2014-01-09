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
  #to be used with cURL calls
#  @input_data = JSON.parse(request.body.read)
  @input_data = params
  read_params
  session = find_session
  if(session)
    session.remainingtime = @input_data['remainingtime']
    session.status = @input_data['status']
    session.touch
  else
    session = Session.new(@input_data)
  end
  save_session(session)
end

post '/remove' do
  content_type :json
  #to be used with cURL calls
#  @input_data = JSON.parse(request.body.read) 
  @input_data = params
  read_params
  session = find_session
  if session
    session.destroy
    session.to_json
  end
end

private
def read_params
  @username = @input_data['username']
  @group = @input_data['group'] 
end

def find_session
  Session.find_by username: @username, group: @group
end

def save_session(session)
  session.save
  generate_return_json(session)
end

def generate_return_json(session)
  Session.where("updated_at < ?", 2.minutes.ago).where(group: session.group).destroy_all
  sessions = Session.where(group: session.group)
  sessions.to_json  
end