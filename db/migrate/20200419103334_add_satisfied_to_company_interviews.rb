class AddSatisfiedToCompanyInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_interviews, :satisfied, :integer
  end
end
