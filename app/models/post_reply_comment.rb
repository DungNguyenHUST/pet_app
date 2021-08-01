class PostReplyComment < ApplicationRecord
    belongs_to :post_comments, optional: true
end
