class CompanyReplyQuestion < ApplicationRecord
    extend FriendlyId
	friendly_id :user_name, use: :slugged
    belongs_to :company_questions, optional: true
end
