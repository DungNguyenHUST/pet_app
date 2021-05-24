class AddUserToCompanyQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :company_questions, :user_id, :integer
    add_column :company_questions, :user_name, :string
  end
end
