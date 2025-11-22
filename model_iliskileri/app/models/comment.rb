class Comment < ApplicationRecord
  # İlişkiler
  belongs_to :post
  belongs_to :user
  
  # Validasyonlar
  validates :content, presence: true, length: { minimum: 2, maximum: 1000 }
  
  # Varsayılan sıralama
  default_scope -> { order(created_at: :asc) }
  
end
