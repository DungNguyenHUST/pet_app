class AddCompanyNameToCompanyInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_interviews, :companyName, :string
  end
end
