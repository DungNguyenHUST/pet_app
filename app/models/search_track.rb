class SearchTrack < ApplicationRecord
    serialize :query, Hash
end
