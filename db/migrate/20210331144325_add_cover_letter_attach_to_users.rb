class AddCoverLetterAttachToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :cover_letter_attach, :string
  end
end
