require 'sinatra'
require 'sinatra/json'

get '/api/' do
	json :message => "Welcome to Study Abroad"
end