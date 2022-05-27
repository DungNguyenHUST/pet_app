class CompanyReplyInterviewQuestion < ApplicationRecord
    belongs_to :company_interview_question
    has_many :company_react_reply_interview_questions
end
