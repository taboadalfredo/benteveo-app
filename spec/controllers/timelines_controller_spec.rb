require 'spec_helper'

describe 'GET /timeline/:username' do
  before do
    @alice = User.create(username: 'alice')
    @bob = User.create(username: 'bob')
    Follow.create(follower: @alice, followed: @bob)
    Message.create(user: @bob, content: 'Mensaje 1', created_at: Time.now)
  end

  it 'retorna mensajes del timeline paginado' do
    get "/timeline/alice?page=1"

    expect(last_response.status).to eq(200)
    data = JSON.parse(last_response.body)
    expect(data).to be_an(Array)
    expect(data.first['content']).to eq('Mensaje 1')
  end
end
