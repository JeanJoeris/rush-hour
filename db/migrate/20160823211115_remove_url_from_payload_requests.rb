class RemoveUrlFromPayloadRequests < ActiveRecord::Migration
  def change
    remove_column :payload_requests, :url
  end
end
