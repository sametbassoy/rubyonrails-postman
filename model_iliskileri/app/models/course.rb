class Course < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :nullify
  has_many :videos, dependent: :destroy

  validates :title, presence: true
end
