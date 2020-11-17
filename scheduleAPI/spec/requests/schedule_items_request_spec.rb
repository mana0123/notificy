require 'rails_helper'

RSpec.describe "ScheduleItems", type: :request do

  before :each do

    # データ生成(二人のユーザでそれぞれ10個づつ)
    @users = FactoryBot.create_list(:active_user, 2)

    @users.each do |user|
      FactoryBot.create_list(:schedule_item, 10, user: user)
      user.schedule_items.each do |schedule_item|
        FactoryBot.create_list(:schedule_item_date, 2, 
                               schedule_item: schedule_item)
      end
    end
  end


  describe 'GET /users/{user_id}/schedule_items' do
    it 'get schedule_items a user' do
      user_id = @users[0].line_id
      get "/users/#{user_id}/schedule_items"
      json = JSON.parse(response.body)

      expect(json['schedule_items'].length).to eq(10)
      expect(json['schedule_items'][0]['dates'].length).to eq(2)
      expect(response.status).to eq(200)
    end

  end

  describe 'POST /users/{user_id}/schedule_items' do
    it 'make new schedule_items' do

      user_id = @users[0].line_id
      valid_params = { dates: [{ year: 2020,
                                 month: 10,
                                 week: nil,
                                 day: 30,
                                 hour: 0 },
                                { year: 2021,
                                 month: 10,
                                 week: nil,
                                 day: 30,
                                 hour: 0 } ] ,
                         content: "ごみの日" }

      expect { post "/users/#{user_id}/schedule_items", 
               params: valid_params, as: :json }
               .to change(ScheduleItem, :count).by(+1)
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /users/{user_id}/schedule_items/{id}' do
    it 'get schedule_items a user' do
      user = @users[0]
      schedule_item = user.schedule_items.first

      get "/users/#{user.id}/schedule_items/#{schedule_item.id}"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
    end

  end

  describe 'PUT /users/{user_id}/schedule_items/{id}' do
    it 'edit the schedule_items' do
      pending '未実装'
      schedule_item = create(:schedule_item)

      put "/schedule_items/#{schedule_item.id}",
                       params: { schedule_items: { year: schedule_item.year,
                                       month: schedule_item.month,
                                       week: schedule_item.week,
                                       day: schedule_item.day,
                                       hour: schedule_item.hour,
                                       user_id: schedule_item.user_id,
                                       content: "【変更後】燃えないごみの日" } }
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json['data']['user']['content']).to eq("【変更後】燃えないごみの日")
      expect(ScheduleItem.find_by(id: schedule_item.id).content).to eq("【変更後】燃えないごみの日")
    end
  end

  describe 'DELETE /users/{user_id}/schedule_items/{id}' do
    it 'delete schedule_item' do

      # 削除対象のITEM
      user = @users[0]
      schedule_item = user.schedule_items.first

      expect { 
        delete "/users/#{user.id}/schedule_items/#{schedule_item.id}" 
      }.to change(ScheduleItem, :count).by(-1).and change(
      ScheduleItemDate, :count).by(-2)

      expect(response.status).to eq(200)
    end
  end
end
