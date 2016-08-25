class Url < ActiveRecord::Base
  has_many :payload_requests

  validates :url_path, presence: true

  def min_response_time
    payload_requests.min_response_time
  end
end
