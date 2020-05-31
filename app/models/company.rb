class Company < ApplicationRecord
    has_many :company_reviews, dependent: :destroy
    has_many :company_interviews, dependent: :destroy
    has_one_attached :avatar
    has_rich_text :content
    has_rich_text :policy

    validate :image_type

    def self.search(search)
        if search
            company_type = Company.find_by(name: search)
            if(company_type)
                self.where(id: company_type)
            else
                @companies = Company.all
            end
        else
            @companies = Company.all
        end
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
