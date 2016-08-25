class Client < ActiveRecord::Base
has_many :payload_requests
has_many :urls, through: :payload_requests
has_many :ips, through: :payload_requests
has_many :referrers, through: :payload_requests
has_many :request_types, through: :payload_requests
has_many :screen_resolutions, through: :payload_requests
has_many :agents, through: :payload_requests

validates :identifier, presence: true
validates :root_url, presence: true

end
