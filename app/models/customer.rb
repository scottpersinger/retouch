# Currently represents a Customer simply by an email address.
class Customer < ActiveRecord::Base
  has_many :photos
end
