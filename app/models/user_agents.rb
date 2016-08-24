class UserAgents < ActiveRecord::Base

validates :os, presents: true
validates :browser, presents: true

def self.format_and_create(data)
  #format the data
  self.create(data)
end

end
