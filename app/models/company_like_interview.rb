class CompanyLikeInterview < ApplicationRecord
  belongs_to :user
  belongs_to :company_interview
end
