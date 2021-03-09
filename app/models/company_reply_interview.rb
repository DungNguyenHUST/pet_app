class CompanyReplyInterview < ApplicationRecord
	extend FriendlyId
	friendly_id :user_name, use: :slugged
    belongs_to :company_interviews, optional: true
end
