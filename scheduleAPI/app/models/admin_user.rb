class AdminUser < ApplicationRecord
  validates :name, presence: true, 
                   length: {maximum: 20, minimum: 6},
                   uniqueness: true
  validates :password_digest, presence: true
  has_secure_password
  validates :password, presence: true,
                       length: {maximum: 20, minimum: 6}

end
