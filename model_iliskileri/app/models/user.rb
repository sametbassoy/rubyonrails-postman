class User < ApplicationRecord
  # User birden fazla Posta sahip olabilir
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :analyses, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :videos, dependent: :destroy
  
  # JWT için gerekli metodlar
  def self.from_token_payload(payload)
    find(payload['sub'])
  end
  
  # Şifre hash'leme için
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  
  private
  
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
