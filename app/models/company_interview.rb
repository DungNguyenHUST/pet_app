class CompanyInterview < ApplicationRecord
    belongs_to :company, optional: true
    has_many :company_reply_interviews, dependent: :destroy
    has_many :company_like_interviews, dependent: :destroy
    has_many :company_dislike_interviews, dependent: :destroy
end
