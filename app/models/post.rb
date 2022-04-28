class Post < ApplicationRecord
    extend FriendlyId
	def convert_slug
        slug = title.downcase.to_s
        slug.gsub! /[àáạãảâậấẫầẩăặắằẵẳ]/, "a"
        slug.gsub! /[đ]/, "d"
        slug.gsub! /[èéẹẽẻêềếệễể]/, "e"
        slug.gsub! /[óòọõỏôốồộỗổơớợỡờở]/, "o"
        slug.gsub! /[úùụũủưứựừữử]/, "u"
        slug.gsub! /[íịìĩỉ]/, "i"
        slug.gsub! /[ýỵỹỳỷ]/, "y"
        return slug
    end
    friendly_id :convert_slug, use: :slugged
        
    has_many :post_comments, dependent: :destroy

    # has_one_attached :wall_picture

    # validates :title, presence: true
    # validates :content, presence: true
        
    def self.approved
        where(approved: :true)
    end

    mount_uploader :wall_picture, ImageUploader
end
