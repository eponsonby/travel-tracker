class User < ActiveRecord::Base
    has_secure_password
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :username, presence: true
    validates :username, uniqueness: true
    validates :password, length: {in: 6..20}
    has_many :trips
    has_many :highlights, through: :trips
end

