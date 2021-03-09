class PostReplyComment < ApplicationRecord
	extend FriendlyId
	friendly_id :user_name, use: :slugged
	
    belongs_to :post_comments, optional: true
end
