class CompanyReplyQuestion < ApplicationRecord
    belongs_to :company_question, optional: true
end
