class CompanyDislikeInterview < ApplicationRecord
  belongs_to :user
  belongs_to :company_interview
end
