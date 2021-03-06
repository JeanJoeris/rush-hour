class Url < ActiveRecord::Base
  has_many :payload_requests

  validates :url_path, presence: true

  def max_response_time
    payload_requests.max_response_time
  end

  def min_response_time
    payload_requests.min_response_time
  end

  def http_verbs
    payload_requests.all_http_verbs
  end

  def http_verbs_report
    payload_requests.all_http_verbs_report
  end

  def response_times
    payload_requests.order(responded_in: :desc).pluck(:responded_in)
  end

  def top_referrers(number = 3)
     Referrer.joins(:payload_requests).where(payload_requests: {url_id: id}).group(:name).order('count(*) DESC').limit(number)
  end

  def top_referrers_report(number = 3)
    top_referrers(number).count.map { |name, count| name }
  end

  def top_agents(number = 3)
    Agent.joins(:payload_requests).where(payload_requests: {url_id: id}).group(:os).order('count(*) DESC').limit(number)
  end

  def top_agents_report(number = 3)
    top_agents(number).count.map { |name, count| name }
  end

  def average_response_time
    payload_requests.average_response_time
  end

end
