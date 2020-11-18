class User < ApplicationRecord
  # name : string  ユーザ名、lineアカウントの場合はline_id
  # password_digest : string  adminユーザのパスワードダイジェスト
  # type : integer 1:admin 2:LINEユーザ
  # status : integer
  # access_digest : LINEユーザ用のアクセスキー
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :user_type, presence: true, 
                        numericality: { only_integer: true },
                        inclusion: { in: 1..2 }
  validates :status, presence: true,
                     numericality: { only_integer: true },
                     inclusion: { in: 0..1 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 },
            if: Proc.new { |user| user.user_type == 1 }

end
