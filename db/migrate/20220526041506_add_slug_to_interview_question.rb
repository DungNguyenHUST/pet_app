class AddSlugToInterviewQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :company_interview_questions, :slug, :string
    add_index :company_interview_questions, :slug, unique: true
  end
end
