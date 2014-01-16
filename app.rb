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
  read_params(params, request)
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
  read_params(params, request)
  session = find_session
  session.destroy if session
  session.to_json
end

get '/fetch' do
  content_type :json
  @group = params[:group]
  generate_return_json
end

private
def read_params(params, request)
  if params.length > 0
    @input_data = params
  else
    @input_data = JSON.parse(request.body.read)
  end
  map_params
end

def map_params
  @username = @input_data['username']
  @group = @input_data['group'] 
end

def find_session
  Session.find_by username: @username, group: @group
end

def save_session(session)
  session.save
  session.to_json
end

def generate_return_json
  Session.where("updated_at < ?", 2.minutes.ago).where(group: @group).destroy_all
  sessions = Session.where(group: @group).order(remainingtime: :asc)
  sessions.to_json  
end