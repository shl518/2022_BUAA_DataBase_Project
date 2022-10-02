class User < ApplicationRecord
  validates :user_name, uniqueness: { case_sensitive: true }, allow_nil: true
  validates :password, presence: true, length: { minimum: 6 }
  # password检测，之后进行测试
  # validate :password_format_check

  def password_format_check
    return unless password.present?
    right = true
    right &&= /.*?\d.*?/ =~ password
    right &&= /.*?[a-zA-Z].*?/ =~ password
    right &&= password.length >= 9 && password.length <= 20
    unless right
      errors.add :password, "password format not legal!"
    end
  end

  # 会话保持
  # attr_accessor :remember_token
  #
  # 密码加密措施 任务一暂时不做
  # def User.digest(string)
  #   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  #   BCrypt::Password.create(string, cost: cost)
  # end
  #
  #
  # def remember
  #   self.remember_token = SecureRandom.urlsafe_base64
  #   update_attribute(:remember_digest, User.digest(remember_token))
  # end
  #
  # def forget
  #   update_attribute(:remember_digest, nil)
  # end
  #
  # def authenticated?(remember_token)
  #   begin
  #     BCrypt::Password.new()
  #   end
  # end
end
