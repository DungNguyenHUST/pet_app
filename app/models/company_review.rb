class CompanyReview < ApplicationRecord
    extend FriendlyId
	friendly_id :review_title, use: :slugged
	
	belongs_to :company, optional: true
    has_many :company_reply_reviews, dependent: :destroy
    has_many :company_like_reviews, dependent: :destroy
    has_many :company_dislike_reviews, dependent: :destroy
    # validates :review, presence: true
end
