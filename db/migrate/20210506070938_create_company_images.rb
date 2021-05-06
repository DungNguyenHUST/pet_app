class CreateCompanyImages < ActiveRecord::Migration[6.1]
  def change
    create_table :company_images do |t|
      t.integer :company_id
      t.string :image

      t.timestamps
    end
  end
end
