class ScreenResolutions < ActiveRecord::Base

  validates :width, presents: true
  validates :height, presents: true

  def self.format_and_create(data)
    #format the data
    self.create(data)
  end

end
