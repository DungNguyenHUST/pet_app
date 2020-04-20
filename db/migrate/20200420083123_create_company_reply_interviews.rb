class CreateCompanyReplyInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :company_reply_interviews do |t|
      t.string :user_name
      t.string :reply_content
      t.integer :company_interview_id

      t.timestamps
    end
  end
end
