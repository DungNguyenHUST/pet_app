class CompanySaveJob < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :company_job, optional: true
end
