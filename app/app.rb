require 'sinatra/base'
require 'sinatra/activerecord'
require 'dotenv/load'
require 'json'

# Carga modelos y servicios
Dir["#{__dir__}/models/*.rb"].each { |file| require file }
Dir["#{__dir__}/services/*.rb"].each { |file| require file }

# Controladores
require_relative 'controllers/messages_controller'
require_relative 'controllers/follows_controller'
require_relative 'controllers/timelines_controller'

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  # Configura la conexión a la base de datos
  set :database_file, File.expand_path('../../config/database.yml', __FILE__)

  before do
    content_type :json
  end

  # Rutas
  use MessagesController
  use FollowsController
  use TimelinesController

  # Endpoint raíz
  get '/' do
    { status: 'ok', message: 'Sinatra API running' }.to_json
  end
end
