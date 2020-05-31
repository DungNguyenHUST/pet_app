class AddCompanyIdToCompanyInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_interviews, :company_id, :integer
  end
end
