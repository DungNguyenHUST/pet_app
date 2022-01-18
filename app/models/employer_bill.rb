class EmployerBill < ApplicationRecord
    belongs_to :employer
    mount_uploader :bill_image, ImageUploader

    def self.confirmed
        where(confirmed: :true)
    end

    def self.confirming
	    where(confirmed: :false)
	end
end
