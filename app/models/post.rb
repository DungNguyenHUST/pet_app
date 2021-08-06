class Post < ApplicationRecord
	extend FriendlyId
	friendly_id :title_coverted, use: :slugged
    
  has_many :post_comments, dependent: :destroy

  # has_one_attached :wall_picture

  # validates :title, presence: true
  # validates :content, presence: true
	
	def self.approved
	  where(approved: :true)
	end

  def self.search(search)
    if search
      post_search = Post.where("title ILIKE?", "%#{search}%")
      if(post_search)
        self.where(id: post_search)
      end
    end
  end

  mount_uploader :wall_picture, ImageUploader
end
