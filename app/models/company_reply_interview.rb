class CompanyReplyInterview < ApplicationRecord
    belongs_to :company_interview, optional: true
end
