class AddColumnsToPayloadRequests < ActiveRecord::Migration
  def change
    add_column :payload_requests, :ip_id, :integer
    add_column :payload_requests, :referrer_id, :integer
    add_column :payload_requests, :user_agent_id, :integer
    add_column :payload_requests, :screen_resolution_id, :integer
    add_column :payload_requests, :request_type_id, :integer
  end
end
