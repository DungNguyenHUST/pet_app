class AddUserIdToCompanyReplyInterviews < ActiveRecord::Migration[6.1]
  def change
    add_column :company_reply_interviews, :user_id, :integer
  end
end
