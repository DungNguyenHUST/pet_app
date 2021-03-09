class PostComment < ApplicationRecord
	extend FriendlyId
	friendly_id :user_name, use: :slugged
	
    belongs_to :post, optional: true
    has_many :post_reply_comments, dependent: :destroy
end
