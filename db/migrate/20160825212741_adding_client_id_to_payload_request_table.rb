class AddingClientIdToPayloadRequestTable < ActiveRecord::Migration
  def change
    add_column :payload_requests, :client_id, :string
  end
end
