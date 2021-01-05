class AddPrivacyToCompanyInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_interviews, :privacy, :boolean, default: false
  end
end
