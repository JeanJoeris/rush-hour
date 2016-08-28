require "JSON"

module JsonTablePopulator

  def self.add(payload, client_id)
    parsed_payload = JSON.parse(payload)
    url= Url.find_or_create_by(url_path: parsed_payload["url"])
    referrer = Referrer.find_or_create_by(name: parsed_payload["referredBy"])
    request_type = RequestType.find_or_create_by(http_verb: parsed_payload["requestType"])
    parsed_agent = UserAgent.parse(parsed_payload["userAgent"].gsub("%3B", ";"))
    agent = Agent.find_or_create_by(os: parsed_agent.os, browser: parsed_agent.browser)
    screen_resolution = ScreenResolution.find_or_create_by(height: parsed_payload["resolutionHeight"], width: parsed_payload["resolutionWidth"])
    ip = Ip.find_or_create_by(address: parsed_payload["ip"])
    PayloadRequest.create(responded_in: parsed_payload["respondedIn"],
                          requested_at: parsed_payload["requestedAt"],
                          url_id: url.id,
                          referrer_id: referrer.id,
                          agent_id: agent.id,
                          request_type_id: request_type.id,
                          screen_resolution_id: screen_resolution.id,
                          ip_id: ip.id,
                          client_id: client_id.to_i )
  end

  def self.validate_json(payload)
    parsed_payload = JSON.parse(payload)
  end

  def self.new(payload, client_id)
    parsed_payload = JSON.parse(payload.gsub("%3B", ";"))
    unless has_nil_values?(parsed_payload)
      url= Url.find_or_create_by(url_path: parsed_payload["url"])
      referrer = Referrer.find_or_create_by(name: parsed_payload["referredBy"])
      request_type = RequestType.find_or_create_by(http_verb: parsed_payload["requestType"])
      parsed_agent = UserAgent.parse(parsed_payload["userAgent"])
      agent = Agent.find_or_create_by(os: parsed_agent.os, browser: parsed_agent.browser)
      screen_resolution = ScreenResolution.find_or_create_by(height: parsed_payload["resolutionHeight"], width: parsed_payload["resolutionWidth"])
      ip = Ip.find_or_create_by(address: parsed_payload["ip"])
      PayloadRequest.new(responded_in: parsed_payload["respondedIn"],
                            requested_at: parsed_payload["requestedAt"],
                            url_id: url.id,
                            referrer_id: referrer.id,
                            agent_id: agent.id,
                            request_type_id: request_type.id,
                            screen_resolution_id: screen_resolution.id,
                            ip_id: ip.id,
                            client_id: client_id)
    end
  end

  def self.has_nil_values?(parsed_payload)
    parsed_payload.values.include?(nil) || parsed_payload.empty?
  end

  def self.payload_already_exists?(payload, client_id)
    parsed_payload = JSON.parse(payload.gsub("%3B", ";"))
    url= Url.find_by(url_path: parsed_payload["url"])
    referrer = Referrer.find_by(name: parsed_payload["referredBy"])
    request_type = RequestType.find_by(http_verb: parsed_payload["requestType"])
    parsed_agent = UserAgent.parse(parsed_payload["userAgent"])
    agent = Agent.find_by(os: parsed_agent.os, browser: parsed_agent.browser)
    screen_resolution = ScreenResolution.find_by(height: parsed_payload["resolutionHeight"], width: parsed_payload["resolutionWidth"])
    ip = Ip.find_by(address: parsed_payload["ip"])
    # if (url || referrer || request_type || parsed_agent || screen_resolution || ip) == nil
    if url == nil || referrer == nil || request_type == nil || agent == nil || screen_resolution == nil || ip == nil
      # require "pry"; binding.pry
      false
    else
      PayloadRequest.exists?(responded_in: parsed_payload["respondedIn"],
                            requested_at: DateTime.strptime(parsed_payload["requestedAt"], "%Y-%m-%d %H:%M:%S %z"),
                            url_id: url.id,
                            referrer_id: referrer.id,
                            agent_id: agent.id,
                            request_type_id: request_type.id,
                            screen_resolution_id: screen_resolution.id,
                            ip_id: ip.id,
                            client_id: client_id)
    end
  end
end
