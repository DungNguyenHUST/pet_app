class CompanyReplyReview < ApplicationRecord
    belongs_to :company_review, optional: true
end
