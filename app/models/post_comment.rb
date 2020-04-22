class PostComment < ApplicationRecord
    belongs_to :post, optional: true
    has_many :post_reply_comments, dependent: :destroy
end
