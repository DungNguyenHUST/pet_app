class CompanyQuestion < ApplicationRecord
  extend FriendlyId
	friendly_id :title, use: :slugged
  belongs_to :company, optional: true
  has_many :company_reply_questions, dependent: :destroy
end
