class CoverVitae < ApplicationRecord
    mount_uploader :avatar, ImageUploader

    def self.sample
	    self.where(sample: :true)
	end
end
