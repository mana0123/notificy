require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe 'GET /users' do
    it 'get all users' do
      get '/users'

      expect(response.status).to eq(200)
    end
  end

end
