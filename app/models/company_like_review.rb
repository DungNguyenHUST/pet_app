class CompanyLikeReview < ApplicationRecord
  belongs_to :company_review
  belongs_to :user
end
