class CreateCompanyInterviewQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :company_interview_questions do |t|

      t.text :question
      t.integer :user_id
      t.integer :company_interview_id
      t.timestamps
    end
  end
end
