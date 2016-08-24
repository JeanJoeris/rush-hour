class RequestTypes < ActiveRecord::Base

  validates :http_verb, presence: true

end
