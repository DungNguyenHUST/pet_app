class CompanyReview < ApplicationRecord
    belongs_to :company, optional: true
end
