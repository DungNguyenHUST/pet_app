class CompanyReplyInterview < ApplicationRecord
    belongs_to :company_interviews, optional: true
end
