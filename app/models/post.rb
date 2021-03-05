class Post < ApplicationRecord
    validates :title, presence: true
    
    has_many :post_comments, dependent: :destroy

    has_one_attached :wall_picture
    
    validates :content_rich_text, presence: true
    has_rich_text :content_rich_text
	
	def self.approved
	  where(approved: :true)
	end
end
