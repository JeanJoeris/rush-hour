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

  def self.all_http_verbs
    RequestType.joins(:payload_requests).pluck(:http_verb).uniq
  end

  def self.ordered_urls
    Url.joins(:payload_requests).group(:url_path).order("count(*) DESC")
  end

  def self.ordered_url_paths
    ordered_urls.count.keys
  end

  def self.browser_breakdown
    Agent.joins(:payload_requests).group(:browser).order('count(*) DESC')
  end

  def self.browser_breakdown_report
    browser_breakdown.count.map { |browser, count| "#{browser}: #{count}" }
  end

  def self.os_breakdown
    Agent.joins(:payload_requests).group(:os).order('count(*) DESC')
  end

  def self.os_breakdown_report
    os_breakdown.count.map { |os, count| "#{os}: #{count}" }
  end

  def self.get_screen_resolution
    ScreenResolution.joins(:payload_requests).distinct.select(:width, :height)
  end

  def self.get_screen_resolution_report
    get_screen_resolution.map do |resolution|
      "#{resolution.width} x #{resolution. height}"
    end
  end

end
