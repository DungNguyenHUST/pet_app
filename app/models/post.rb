class Post < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    
    has_many :post_comments, dependent: :destroy
end
