require 'sinatra'
require 'sinatra/activerecord'
require './config/environments.rb'
require './models/session'
require 'json'

get '/' do 
#  Session.all.each do |session|
#    erb :session
#  end
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
  if session
    session.destroy 
    session.to_json
  else
    Array.new.to_json
  end
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

def remove_old_sessions_and_get_active_sessions_in_group
  remove_old_sessions
  get_active_sessions_in_group
end

def remove_old_sessions
  Session.where("updated_at < ?", 2.minutes.ago).where(group: @group).destroy_all
end

def get_active_sessions_in_group
  Session.where(group: @group).order(remainingtime: :asc)
end

def generate_return_json
  sessions = remove_old_sessions_and_get_active_sessions_in_group
  sessions.to_json  
end

__END__

#layout
@@ layout
<html>
<body>
  <ul>
  <%= yield %>
</ul>
</body>
</html>

@@ session
<li><%= session.username%></li>
