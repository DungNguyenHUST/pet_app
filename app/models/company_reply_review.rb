class CompanyReplyReview < ApplicationRecord
    belongs_to :company_reviews, optional: true
end
