class CompanyReview < ApplicationRecord
    belongs_to :company, optional: true
    has_many :company_reply_reviews, dependent: :destroy
    has_many :company_like_reviews, dependent: :destroy
    has_many :company_dislike_reviews, dependent: :destroy
    validates :review_rich_text, presence: true
    has_rich_text :review_rich_text
end
