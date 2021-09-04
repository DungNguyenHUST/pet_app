class AddCompanyImageToJob < ActiveRecord::Migration[6.1]
  def change
    add_column :company_jobs, :company_avatar, :string
  end
end
