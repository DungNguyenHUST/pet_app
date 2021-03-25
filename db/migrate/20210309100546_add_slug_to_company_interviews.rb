class AddSlugToCompanyInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_interviews, :slug, :string
    add_index :company_interviews, :slug, unique: true
  end
end
