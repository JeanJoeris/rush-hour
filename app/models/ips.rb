class Ips < ActiveRecord::Base

  validates :address, presents: true

  def self.format_and_create(data)
    #format the data
    self.create(data)
  end

end
