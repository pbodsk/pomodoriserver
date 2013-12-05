require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/pomodoriSession'
require 'json'


get '/' do 
  "Hello World"
end

=begin
before do
  if request.request_method == "POST"
    body_parameters = request.body.read
    params.merge!(JSON.parse(body_parameters))
  end
end
=end

post '/update' do
  content_type :json
  @input_data = JSON.parse(request.body.read)
  @pomodori_session = PomodoriSession.new(@input_data)
  if(@pomodori_session.save)
    "saved!"
  else
    "not saved"
  end
end