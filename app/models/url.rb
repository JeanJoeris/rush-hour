class Url < ActiveRecord::Base
  has_many :payload_requests

  validates :url_path, presence: true

  def max_response_time
    payload_requests.max_response_time
  end

  def http_verbs
    request_types = payload_requests.select("request_type_id")
    request_types.map do |request_type|
      RequestType.find(request_type.request_type_id).http_verb
    end
  end

end
