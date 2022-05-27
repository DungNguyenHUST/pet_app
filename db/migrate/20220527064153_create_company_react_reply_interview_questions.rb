class CreateCompanyReactReplyInterviewQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :company_react_reply_interview_questions do |t|
      t.integer "user_id"
      t.integer "react_type", :default => -1
      t.integer "company_reply_interview_question_id"

      t.timestamps
    end
  end
end
