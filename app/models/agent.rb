class Agent < ActiveRecord::Base
  has_many :payload_requests

  validates :os, presence: true
  validates :browser, presence: true

  def self.finds_all_browsers
    Agent.pluck(:browser).uniq
  end

  def self.finds_all_os
    Agent.pluck(:os).uniq
  end

end
