class RequestType < ActiveRecord::Base
  has_many :payload_requests

  validates :http_verb, presence: true

end
