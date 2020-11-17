class ScheduleItem < ApplicationRecord
  # user_id : integer
  # status : integer 0:Disabled 1:Enabled
  # content : text
  # schedule_date_id : integer

  belongs_to :user, primary_key: :line_id
  has_many :schedule_item_dates, dependent: :destroy

  validates :user_id, presence: true
  validates :status, presence: true,
                     numericality: { only_integer: true },
                     inclusion: { in: 0..1 }
  validates :content, presence: true,
                      length: { in: 1..200 }
end
