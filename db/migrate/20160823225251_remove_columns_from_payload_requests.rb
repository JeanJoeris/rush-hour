class RemoveColumnsFromPayloadRequests < ActiveRecord::Migration
  def change
    remove_column :payload_requests, :referred_by
    remove_column :payload_requests, :request_type
    remove_column :payload_requests, :user_agent
    remove_column :payload_requests, :resolution_width
    remove_column :payload_requests, :resolution_height
    remove_column :payload_requests, :ip
  end
end
