class Company < ApplicationRecord
    has_many :company_reviews, dependent: :destroy
    has_many :company_interviews, dependent: :destroy
    has_many :company_jobs, dependent: :destroy
    has_many :company_follows, dependent: :destroy
    has_many :user, dependent: :destroy
    
    has_one_attached :avatar
    has_one_attached :wall_picture

    validate :image_type

    validates :overview_rich_text, presence: true
    validates :policy_rich_text, presence: true
    has_rich_text :overview_rich_text
    has_rich_text :policy_rich_text

    def self.search(search)
        if search
            company_type = Company.where("name ILIKE? OR location ILIKE?", "%#{search}%", "%#{search}%")
            if(company_type)
                self.where(id: company_type)
            else
                @companies = Company.all
            end
        else
            @companies = Company.all
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
