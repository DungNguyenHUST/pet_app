class CompanyReview < ApplicationRecord
	belongs_to :company, optional: true
    has_many :company_reply_reviews, dependent: :destroy
    has_many :company_react_reviews, dependent: :destroy
    # validates :review, presence: true
end
