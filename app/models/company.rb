class Company < ApplicationRecord
	extend FriendlyId
	def convert_slug
        slug = name.downcase.to_s
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
    
    # For Search
    searchkick
    def search_data
    {
        name: name
    }
    end
	
    has_many :company_reviews, dependent: :destroy
    has_many :company_interviews, dependent: :destroy
    has_many :company_follows, dependent: :destroy
    has_many :company_images, dependent: :destroy
    has_many :company_questions, dependent: :destroy
    has_many :company_salaries, dependent: :destroy
    accepts_nested_attributes_for :company_images

    mount_uploader :avatar, ImageUploader

	def self.approved
		where(approved: :true)
	end

    private

    def image_type
        if avatar.attached? == false
            errors.add(:avatar, "is missing!")
        end
        if !avatar.content_type.in?(%('image/jpeg image/png'))
            errors.add(:avatar, "needs to be a jpeg or png!")
        end
    end
end
