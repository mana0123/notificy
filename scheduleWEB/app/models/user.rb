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
  has_secure_password(validations: false)
  validates :password, presence: true, length: { minimum: 6 },
            if: Proc.new { |user| user.user_type == 1 }, on: :create

  attr_accessor :access_token

  def create_new_access_token
    self.access_token = User.new_token
    update_attributes(access_digest: User.digest(access_token), access_at: Time.zone.now)
  end

  def authenticate_access_token?(token)
    BCrypt::Password.new(self.access_digest).is_password?(token)
  end

  def access_token_expired?
    self.access_at < 30.minutes.ago
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end
