class User < ApplicationRecord
  has_secure_password
  has_one_attached :profile_pic
  before_create :set_default_avatar

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true, format: {
    with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, 
    message: 'имеет недопустимый формат'
  }
  validates :secret_word, presence: true, format: {
    with: /\A[a-z]+\d*\z/i,
    message: 'имеет недопустимый формат (допускаются только латинские буквы и цифры)'
  }

  def set_default_avatar
    self.profile_pic.attach(io: open('/Users/bigsoulja/Documents/default-avatar.png'), filename: 'default-avatar.png')
  end
end
