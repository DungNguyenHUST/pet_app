class CreateCompanyReplyInterviewQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :company_reply_interview_questions do |t|

      t.text :answer
      t.integer :user_id
      t.integer :company_interview_question_id
      t.timestamps
    end
  end
end
