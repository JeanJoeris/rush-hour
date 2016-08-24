class RequestTypes < ActiveRecord::Base

  validates :http_verb, presents: true

  def self.format_and_create(data)
    #format the data
    self.create(data)
  end

end
