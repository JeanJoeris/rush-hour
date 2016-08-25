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
    # require "pry"; binding.pry
    # id = group(:request_type_id).count.max_by{ |k,v| v }.first
    # RequestType.find(id).http_verb
    # RequestType.joins(:payload_requests).group(:id).first.http_verb
    RequestType.joins(:payload_requests).group(:http_verb).order('count(*) DESC').count.keys.first
  end

  def self.all_http_verbs
    ids = pluck(:request_type_id).uniq
    ids.map {|id| RequestType.find(id).http_verb}
  end

  def self.ordered_urls
    url_ids = group(:url_id).order('count(*) DESC').count.keys
    url_ids.map{|id| Url.find(id)}
  end

  def self.ordered_url_paths
    ordered_urls.map{|url| url.url_path}
  end

  def self.browser_breakdown
    # require "pry"; binding.pry

    # counted_agent_ids = group(:agent_id).order('count(*) DESC').count
    # counted_agent_ids.map do |agent_id, count|
    #   "#{Agent.find(agent_id).browser}: #{count}"
    Agent.joins(:payload_requests).group(:browser).order('count(*) DESC').count
    # end
  end

  def self.os_breakdown
    counted_agent_ids = group(:agent_id).order('count(*) DESC').count
    counted_agent_ids.map do |agent_id, count|
      "#{Agent.find(agent_id).os}: #{count}"
    end
  end

  def self.get_screen_resolution
    screen_resolution = pluck(:screen_resolution_id).uniq
    screen_resolution.map do |id|
      "#{ScreenResolution.find(id).width} x #{ScreenResolution.find(id).height}"
    end
  end

end
