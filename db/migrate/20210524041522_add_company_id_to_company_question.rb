class AddCompanyIdToCompanyQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :company_questions, :company_id, :integer
  end
end
