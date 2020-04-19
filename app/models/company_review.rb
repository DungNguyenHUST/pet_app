class CompanyReview < ApplicationRecord
    belongs_to :company, optional: true
    has_many :company_reply_reviews, dependent: :destroy
end
