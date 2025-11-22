class Analysis < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :title, :content, presence: true
end
