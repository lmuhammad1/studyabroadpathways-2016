require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/config_file'
require 'sinatra/content_for'
require './config/app-config'

ENV['RACK_ENV'] ||= 'development'
set :public_folder, Config['public_dir']
enable :sessions
set :session_secret, Config['session_secret']

configure do
	if ENV['DATABASE_URL'].blank?
		config_file 'config/development.yml'
		db_config = YAML.load(File.read('config/database.yml'))
		ActiveRecord::Base.establish_connection db_config['development']
	else
		ActiveRecord::Base.establish_connection ENV['DATABASE_URL']
	end

	Dir["./src/api/models/*.rb"].each { |model| require model }
	Dir["./src/api/rest/*.rb"].each { |route| require route }

	enable :sessions

	$stdout.sync = true

	get '/'do
		send_file File.join(settings.public_folder, 'index.html')
	end
end