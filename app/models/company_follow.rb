class CompanyFollow < ApplicationRecord
  belongs_to :user
  belongs_to :company
end
