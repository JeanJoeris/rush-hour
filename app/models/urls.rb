class Urls < ActiveRecord::Base

  validates :url_path, presents: true

  def self.format_and_create(data)
    #format the data
    self.create(data)
  end

end
