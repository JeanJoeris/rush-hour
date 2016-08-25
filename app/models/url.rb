class Url < ActiveRecord::Base
  has_many :payload_requests

  validates :url_path, presence: true

  def min_response_time
    payload_requests.min_response_time
  end

  def response_times
    payload_requests.order(responded_in: :desc).pluck(:responded_in)
  end

  def top_referrers(number = 3)
    referrer_ids = payload_requests.group(:referrer_id).order('count(*) DESC').limit(number).count.keys
    referrer_ids.map { |id| Referrer.find(id) }
  end

  def top_referrer_paths(number = 3)
    top_referrers(number).map { |referrer| referrer.name }
  end

  def average_response_time
    payload_requests.average_response_time
  end
end
