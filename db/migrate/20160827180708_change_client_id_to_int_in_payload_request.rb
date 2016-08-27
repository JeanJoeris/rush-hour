class ChangeClientIdToIntInPayloadRequest < ActiveRecord::Migration
  def change
    change_column :payload_requests, :client_id, "integer USING CAST(client_id AS integer)"
  end
end
