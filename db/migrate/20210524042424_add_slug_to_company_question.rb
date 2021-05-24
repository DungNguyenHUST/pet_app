class AddSlugToCompanyQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :company_questions, :slug, :string
    add_index :company_questions, :slug, unique: true
  end
end
