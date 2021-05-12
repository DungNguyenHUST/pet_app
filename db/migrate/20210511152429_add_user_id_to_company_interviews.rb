class AddUserIdToCompanyInterviews < ActiveRecord::Migration[6.1]
  def change
    add_column :company_interviews, :user_id, :integer
  end
end
