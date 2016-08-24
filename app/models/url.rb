class Url < ActiveRecord::Base
  has_many :payload_requests

  validates :url_path, presence: true

end
