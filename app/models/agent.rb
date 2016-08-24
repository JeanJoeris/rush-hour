class Agent < ActiveRecord::Base
  has_many :payload_requests

  validates :os, presence: true
  validates :browser, presence: true

end
