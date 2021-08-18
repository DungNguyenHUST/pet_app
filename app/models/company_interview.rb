class CompanyInterview < ApplicationRecord
    belongs_to :company, optional: true
    has_many :company_reply_interviews, dependent: :destroy
    has_many :company_react_interviews, dependent: :destroy
    # validates :content, presence: true
end
