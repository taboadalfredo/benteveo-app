require 'spec_helper'

describe 'POST /messages' do
  it 'crea un mensaje y lo guarda en la base de datos' do
    post '/messages', { username: 'alice', content: 'Hola mundo' }.to_json,
         { 'CONTENT_TYPE' => 'application/json' }

    expect(last_response.status).to eq(201)

    data = JSON.parse(last_response.body)
    expect(data['content']).to eq('Hola mundo')
    expect(data['id']).not_to be_nil
  end
end
