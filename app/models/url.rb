class Url < ActiveRecord::Base
  has_many :payload_requests

  validates :url_path, presence: true

  def max_response_time
    payload_requests.max_response_time
  end

  def http_verbs
    RequestType.where(id: payload_requests.select("request_type_id")).pluck(:http_verb)
  end

  def top_agents(number = 3)
    # Agent.where(id: payload_requests.group(:agent_id).order('count_id DESC').limit(number).count(:id).keys)

    top_agent_ids = payload_requests.group(:agent_id).order('count_id DESC').limit(number).count(:id)
    top_agent_ids.map do |agent_id, count|
      Agent.find(agent_id)
    end
  end

end
