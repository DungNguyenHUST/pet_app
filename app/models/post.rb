class Post < ApplicationRecord
    include PgSearch::Model
    
    extend FriendlyId
    friendly_id :title_converted, use: :slugged
        
    has_many :post_comments, dependent: :destroy

    # has_one_attached :wall_picture

    # validates :title, presence: true
    # validates :content, presence: true
        
    def self.approved
        where(approved: :true)
    end

    pg_search_scope :search_post_by_title, 
                    against: :title,
                    using: {
                        tsearch: { prefix: true, dictionary: "english", any_word: true }
                    }

    mount_uploader :wall_picture, ImageUploader
end
