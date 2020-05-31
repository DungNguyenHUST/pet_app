class CompanyInterview < ApplicationRecord
    belongs_to :company, optional: true
    has_many :company_reply_interviews, dependent: :destroy
end
