class Post < ApplicationRecord
    has_many :post
    validates :title, presence: true
    validates :content, presence: true
    
    has_many :comments, dependent: :destroy
end
