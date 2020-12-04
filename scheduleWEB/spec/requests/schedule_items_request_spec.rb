require 'rails_helper'

RSpec.describe "ScheduleItems", type: :request do

  include SessionsHelper

  before do
      user = User.create(name: "1", user_type: 1, status: 1, password: "testtest")
      allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ user_id: user.id })
  end

  describe 'POST /users/{:user_id}/schedule_items' do
    it 'post schedule_items' do
      post '/users/1/schedule_items', 
           params: {content: "testtesttest", dates: 
            {"0": {"date_type": "fixed", "full_date": "2020-12-04", "hour": "20"},
            "1": {"date_type": "rooped", "roop_type": "1", "month": "11",
                  "day": "19", "hour": "17"},
            "2": {"date_type": "rooped", "roop_type": "2", "day": "30",
                  "hour": "17", "month_type": "date"},
            "3": {"date_type": "rooped", "roop_type": "2", "dainan": "3",
                  "week": "6", "hour": "17", "month_type": "week"},
            "4": {"date_type": "rooped", "roop_type": "3", "week": "6", "hour": "18"},
            "5": {"date_type": "rooped", "roop_type": "4", "hour": "18"},
            "6": {"date_type": "rooped", "roop_type": "5"}}}
      expect(response.status).to eq(200)
    end
  end

end
