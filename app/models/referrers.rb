
class Referrer < ActiveRecord::Base
  has_many :payload_requests

  validates :name, presence: true

end
