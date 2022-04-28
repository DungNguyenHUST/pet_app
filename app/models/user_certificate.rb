class UserCertificate < ApplicationRecord
    belongs_to :user
    
    # For Search
    searchkick
    after_commit :reindex_user
    def reindex_user
        user.reindex
    end
end
