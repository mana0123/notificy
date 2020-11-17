class ContentItem < ApplicationRecord
  # content : text

  validates :content, presence: true,
                      length: { in: 1..200 }
                    
  has_many :schedule_items
  has_many :users, through: :schedule_items

end
