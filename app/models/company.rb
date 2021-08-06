class Company < ApplicationRecord
	extend FriendlyId
	friendly_id :name_converted, use: :slugged
	
    has_many :company_reviews, dependent: :destroy
    has_many :company_interviews, dependent: :destroy
    has_many :company_jobs, dependent: :destroy
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

    def self.search(search)
        if search
            company_search = Company.where("name_converted ILIKE?", "%#{search}%")
            if(company_search)
                self.where(id: company_search)
            end
        end
    end
	
	def self.search_advance(search, location)
        if search && location
            company_search = Company.where("name_converted ILIKE? AND location_converted ILIKE?", "%#{search}%", "%#{location}%")
            if(company_search)
                self.where(id: company_search)
            end
        end
    end
	
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
