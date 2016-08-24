class UserAgents < ActiveRecord::Base

validates :os, presence: true
validates :browser, presence: true

end
