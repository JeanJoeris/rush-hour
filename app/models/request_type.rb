class RequestType < ActiveRecord::Base
  has_many :payload_requests

  validates :http_verb, presence: true

  def self.all_http_verbs_used
    RequestType.pluck(:http_verb)
  end

end
