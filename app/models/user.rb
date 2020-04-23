class User < ApplicationRecord
    # using encryt pass
    has_secure_password
    has_one_attached :avatar

    has_many :company_like_reviews, dependent: :destroy
    has_many :company_dislike_reviews, dependent: :destroy

    validate :image_type

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
