class CompanyReplyQuestion < ApplicationRecord
    belongs_to :company_questions, optional: true
end
