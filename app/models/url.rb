class Url < ActiveRecord::Base
  has_many :payload_requests

  validates :url_path, presence: true

  def min_response_time
    payload_requests.min_response_time
  end

  def response_times
    payload_requests.map { |pl| pl.responded_in }.sort.reverse
  end

  def most_popular
    payload_requests.group(:referrer_id).order('count(*) DESC').limit(3).count.keys
  end
end
