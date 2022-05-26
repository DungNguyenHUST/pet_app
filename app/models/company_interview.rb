class CompanyInterview < ApplicationRecord
    belongs_to :company, optional: true
    has_many :company_reply_interviews, dependent: :destroy
    has_many :company_react_interviews, dependent: :destroy
    has_many :company_interview_questions, dependent: :destroy
    accepts_nested_attributes_for :company_interview_questions, allow_destroy: true
    # validates :content, presence: true
end
