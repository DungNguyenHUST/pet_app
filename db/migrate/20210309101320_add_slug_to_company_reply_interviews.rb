class AddSlugToCompanyReplyInterviews < ActiveRecord::Migration[6.1]
  def change
    add_column :company_reply_interviews, :slug, :string
    add_index :company_reply_interviews, :slug, unique: true
  end
end
