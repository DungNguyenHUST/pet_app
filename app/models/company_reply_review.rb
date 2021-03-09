class CompanyReplyReview < ApplicationRecord
	extend FriendlyId
	friendly_id :user_name, use: :slugged
	
    belongs_to :company_reviews, optional: true
end
