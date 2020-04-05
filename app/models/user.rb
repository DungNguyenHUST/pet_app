class User < ApplicationRecord
    # using encryt pass
    has_secure_password
end
