class CompanyReview < ApplicationRecord
	belongs_to :company, optional: true
    has_many :company_reply_reviews, dependent: :destroy
    has_many :company_like_reviews, dependent: :destroy
    has_many :company_dislike_reviews, dependent: :destroy
    # validates :review, presence: true
end
