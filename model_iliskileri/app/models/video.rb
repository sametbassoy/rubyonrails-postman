class Video < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :title, :url, presence: true
end
