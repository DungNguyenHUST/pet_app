class AddProcessToCompanyInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_interviews, :process, :integer
  end
end
