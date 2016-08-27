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
                          client_id: client_id )
  end

  def validate_json(payload)
    
  end
end
