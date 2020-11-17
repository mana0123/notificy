class User < ApplicationRecord

  # type :string 
  # line_id :string
  # status  :integer 0:Disabled 1:Enabled
  # access_token :string
  # access_token_digest :string

#  attr_accessor :access_token
  self.primary_key = :line_id

  validates :user_type, presence: true, 
                        inclusion: { in: %w(user group room) }
  validates :line_id, presence: true
  validates :status, presence: true,
                     numericality: { only_integer: true },
                     inclusion: { in: 0..1 }

  has_many :schedule_items, dependent: :destroy
  has_many :schedule_item_dates, through: :schedule_items

end
