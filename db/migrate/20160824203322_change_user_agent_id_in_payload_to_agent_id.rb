class ChangeUserAgentIdInPayloadToAgentId < ActiveRecord::Migration
  def change
    rename_column :payload_requests, :user_agent_id, :agent_id
  end
end
