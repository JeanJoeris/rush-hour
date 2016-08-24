class Urls < ActiveRecord::Base

  validates :url_path, presence: true

end
