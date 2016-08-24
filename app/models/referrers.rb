class Referrers < ActiveRecord::Base

  validates :name, presents: true

  def self.format_and_create(data)
    #format the data
    self.create(data)
  end

end
