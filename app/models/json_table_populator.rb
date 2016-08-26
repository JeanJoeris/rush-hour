require "JSON"

module JsonTablePopulator

  def self.add(payload)
    parsed_payload = JSON.parse(payload)
    Url.find_or_create_by(url_path: parsed_payload["url"])
    Referrer.find_or_create_by(name: parsed_payload["url"])
    RequestType.find_or_create_by(requestType: parsed_payload["url"])
    Agent.find_or_create_by(: parsed_payload["url"])
    ScreenResolution.find_or_create_by(url_path: parsed_payload["url"])
    Ip.find_or_create_by(url_path: parsed_payload["url"])
  end

end
