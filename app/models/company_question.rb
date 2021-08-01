class CompanyQuestion < ApplicationRecord
  belongs_to :company, optional: true
  has_many :company_reply_questions, dependent: :destroy
end
