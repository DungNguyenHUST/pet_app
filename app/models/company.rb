class Company < ApplicationRecord
    include PgSearch::Model

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
	
    has_many :company_reviews, dependent: :destroy
    has_many :company_interviews, dependent: :destroy
    has_many :company_follows, dependent: :destroy
    has_many :company_images, dependent: :destroy
    has_many :company_questions, dependent: :destroy
    has_many :company_salaries, dependent: :destroy
    accepts_nested_attributes_for :company_images
    
    # has_one_attached :avatar
    # has_one_attached :wall_picture

    # validate :image_type
    mount_uploader :avatar, ImageUploader
    mount_uploader :wall_picture, ImageUploader

    # validates :overview, presence: true
    # validates :policy, presence: true

    pg_search_scope :search_company_by_name, 
                    against: :name,
                    using: {
                        tsearch: { prefix: true, dictionary: "english", any_word: true, tsvector_column: "tsv" }
                    }

	
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
