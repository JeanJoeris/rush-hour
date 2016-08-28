class PayloadRequest < ActiveRecord::Base
  belongs_to :ip
  belongs_to :referrer
  belongs_to :request_type
  belongs_to :screen_resolution
  belongs_to :url
  belongs_to :agent
  belongs_to :client

  validates :requested_at, presence: true
  validates :responded_in, presence: true
  validates :ip_id, presence: true
  validates :url_id, presence: true
  validates :referrer_id, presence: true
  validates :agent_id, presence: true
  validates :screen_resolution_id, presence: true
  validates :request_type_id, presence: true
  validates :client_id, presence: true

  def self.average_response_time
    average(:responded_in)
  end

  def self.min_response_time
    minimum(:responded_in)
  end

  def self.max_response_time
    maximum(:responded_in)
  end

  def self.most_used_request_type
    RequestType.joins(:payload_requests).group(:http_verb).order('count(*) DESC').count.keys.first
  end

  def self.all_http_verbs_report
    all_http_verbs.count.map { |verb, count| "#{verb}: #{count}" }
  end

  def self.all_http_verbs(client_id = 1)
    RequestType.joins(:payload_requests).where(payload_requests: { client_id: client_id }).group(:http_verb).order("count(*) DESC")
  end

  def self.ordered_urls(client_id = 1)
    Url.joins(:payload_requests).where(payload_requests: { client_id: client_id }).group(:url_path).order("count(*) DESC")
  end

  def self.ordered_url_paths
    ordered_urls.count.keys
  end

  def self.browser_breakdown(client_id = 1)
    Agent.joins(:payload_requests).where(payload_requests: { client_id: client_id }).group(:browser).order('count(*) DESC')
  end

  def self.browser_breakdown_report
    browser_breakdown.count.map { |browser, count| "#{browser}: #{count}" }
  end

  def self.os_breakdown(client_id = 1)
    Agent.joins(:payload_requests).where(payload_requests: { client_id: client_id }).group(:os).order('count(*) DESC')
  end

  def self.os_breakdown_report
    os_breakdown.count.map { |os, count| "#{os}: #{count}" }
  end

  def self.get_screen_resolution(client_id = 1)
    ScreenResolution.joins(:payload_requests).where(payload_requests: { client_id: client_id }).distinct.select(:width, :height)
  end

  def self.get_screen_resolution_report(client_id = 1)
    get_screen_resolution(client_id).map do |resolution|
      "#{resolution.width} x #{resolution. height}"
    end
  end

end
