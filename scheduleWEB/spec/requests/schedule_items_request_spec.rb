require 'rails_helper'

RSpec.describe "ScheduleItems", type: :request do

  describe 'POST /users/{:user_id}/schedule_items' do
    it 'post schedule_items' do
      post '/users/1/schedule_items', 
           params: { post: { content: "test",
                     dates:  {
                     year: "",
                     month: "",
                     week: "",
                     day: "",
                     hour: "" } } }

      expect(response.status).to eq(200)
    end
  end

end
