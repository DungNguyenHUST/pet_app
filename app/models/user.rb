class User < ApplicationRecord
    # using encryt pass
    has_secure_password
    has_one_attached :avatar
    has_one_attached :cover_letter_attach

    has_many :company_like_reviews, dependent: :destroy
    has_many :company_dislike_reviews, dependent: :destroy
    
end
