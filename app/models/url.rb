class Url < ActiveRecord::Base
  has_many :payload_requests

  validates :url_path, presence: true

  def self.ordered_urls
    Url.pluck(:url_path)
  end

end
