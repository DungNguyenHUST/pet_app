class Post < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    
    has_many :post_comments, dependent: :destroy

    has_one_attached :wall_picture
    has_rich_text :content_rich
end
