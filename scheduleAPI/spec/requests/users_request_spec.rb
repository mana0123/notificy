require 'rails_helper'

RSpec.describe 'Users', type: :request do
  
  before :each do
    # データ生成
    @users = FactoryBot.create_list(:active_user, 10)

    @users.each do |user|
      FactoryBot.create_list(:schedule_item, 10, user: user)
      user.schedule_items.each do |schedule_item|
        FactoryBot.create_list(:schedule_item_date, 2,
                               schedule_item: schedule_item)
      end
    end

  end

  describe 'GET /users' do
    it 'get all users' do
      get '/users'
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json['users'].length).to eq(10)
    end

    it 'get all users but no user' do
      @users.each do |user|
        user.destroy
      end

      get '/users'
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json['users'].length).to eq(0)

    end
  end

  describe 'POST /users' do
    describe 'normal test' do
      it 'make new users user_type room' do
        valid_params = { user_type: 'room', line_id: '11111abcd' }
        expect { 
          post '/users', params: valid_params 
        }.to change(User, :count).by(+1)
        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(json['user']['line_id']).to eq("11111abcd")
      end

      it 'make new users user_type user' do

        valid_params = { user_type: 'user', line_id: '11111abcd' }
        expect { 
          post '/users', params: valid_params
        }.to change(User, :count).by(+1)
        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(json['user']['line_id']).to eq("11111abcd")
      end

      it 'make new users user_type group' do

        valid_params = { user_type: 'group', line_id: '11111abcd' }
        expect {
          post '/users', params: valid_params  
        }.to change(User, :count).by(+1)
        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(json['user']['line_id']).to eq("11111abcd")
      end
    end

    describe 'abnormal test' do
      it 'not exist user_type request' do
        valid_params = { user_type: 'test', line_id: '11111abcd' }

        expect {
          post '/users', params: valid_params
        }.to change(User, :count).by(0)
        json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(json['messages'].length).to be >= 1
      end

      it 'user_type is empty' do
        valid_params = { user_type: '', line_id: '11111abcd' }

        expect {
          post '/users', params: valid_params
        }.to change(User, :count).by(0)
        json = JSON.parse(response.body)
        expect(response.status).to eq(400)
        expect(json['messages'].length).to be >= 1
      end

      it 'line_id is no param' do
        valid_params = { user_type: 'room' }

        expect {
          post '/users', params: valid_params
        }.to change(User, :count).by(0)
        json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(json['messages'].length).to be >= 1
      end
    end
  end

  describe 'PUT /users/:id' do
    it 'edit the user' do
      pending '未実装'
      user = create(:active_user)

      put "/users/#{user.id}", params: { user: { status: 0 } }
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json['data']['user']['room_id']).to eq(user.room_id)
      expect(User.find_by(id: user.id).status).to eq(0)
    end
  end

  describe 'DELETE /users/:id' do
    describe 'normal test' do
      it 'delete user' do
        # 削除対象のユーザ
        user = @users[0]
  
        # 【事前確認】削除対象のユーザが存在することを確認
        expect(User.find_by(line_id: user.line_id)).to eq(user)

        # 実行＆確認
        expect { 
          delete "/users/#{user.id}" 
        }.to change(User, :count).by(-1).and change(
        ScheduleItem, :count).by(-10).and change(
        ScheduleItemDate, :count).by(-20)
  
        expect(User.find_by(line_id: user.line_id)).to eq(nil)
        expect(response.status).to eq(200)
      end
    end

    describe 'abnormal test' do
      it 'delete not exist user' do

        # 削除対象ユーザ
        user_id = "test"
         
        # 【事前確認】削除対象のユーザが存在することを確認
        expect(User.find_by(line_id: user_id)).to eq(nil)

        # 実行＆確認
        expect {
          delete "/users/#{user_id}"
        }.to change(User, :count).by(0).and change(
        ScheduleItem, :count).by(0).and change(
        ScheduleItemDate, :count).by(0)
        json = JSON.parse(response.body)

        expect(response.status).to eq(404)
        expect(json['messages'].length).to be >= 1
      end
    end
  end
end
