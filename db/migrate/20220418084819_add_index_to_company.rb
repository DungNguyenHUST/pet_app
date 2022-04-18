class AddIndexToCompany < ActiveRecord::Migration[6.1]
  def change
    add_index :company_reviews, :company_id
    add_index :company_interviews, :company_id
    add_index :company_salaries, :company_id
  end
end
