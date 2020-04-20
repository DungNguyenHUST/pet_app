class AddOfferToCompanyInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_interviews, :offer, :bool
  end
end
