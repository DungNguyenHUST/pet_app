class AddGetInterviewToCompanyInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_interviews, :get_interview, :string
  end
end
