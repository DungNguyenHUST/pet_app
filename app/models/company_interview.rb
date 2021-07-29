class CompanyInterview < ApplicationRecord
    extend FriendlyId
    def convert_slug
        slug = position.downcase.to_s
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
	
    belongs_to :company, optional: true
    has_many :company_reply_interviews, dependent: :destroy
    has_many :company_like_interviews, dependent: :destroy
    has_many :company_dislike_interviews, dependent: :destroy
    
    # validates :content, presence: true
end
