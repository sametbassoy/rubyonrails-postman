class Post < ApplicationRecord
  # İlişkiler
  belongs_to :user
  belongs_to :subject, optional: true
  belongs_to :course, optional: true
  has_many :comments, dependent: :destroy
  has_many :analyses, dependent: :destroy
  
  # Validasyonlar
  validates :title, presence: true, length: { minimum: 5 }
  validates :content, presence: true
  
  # Varsayılan sıralama
  default_scope -> { order(created_at: :desc) }
  
  # Kullanıcı dostu URL'ler için
  def to_param
    [id, title.parameterize].join('-')
  end
end
