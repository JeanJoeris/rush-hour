require "JSON"

module JsonTablePopulator

  def self.add(payload)
    parsed_payload = JSON.parse(payload)
    Url.find_or_create_by(url_path: parsed_payload["url"])
    Referrer.find_or_create_by(name: parsed_payload["referredBy"])
    RequestType.find_or_create_by(http_verb: parsed_payload["requestType"])
    parsed_agent = UserAgent.parse(parsed_payload["userAgent"])
    Agent.find_or_create_by(os: parsed_agent.os, browser: parsed_agent.browser)
    ScreenResolution.find_or_create_by(height: parsed_payload["resolutionHeight"], width: parsed_payload["resolutionWidth"])
    Ip.find_or_create_by(address: parsed_payload["ip"])
  end

end
