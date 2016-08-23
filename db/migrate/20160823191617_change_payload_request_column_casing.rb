class ChangePayloadRequestColumnCasing < ActiveRecord::Migration
  def change
    change_table :payload_requests do |t|
      t.rename :requestedAt, :requested_at
      t.rename :respondedIn, :responded_in
      t.rename :referredBy, :referred_by
      t.rename :requestType, :request_type
      t.rename :userAgent, :user_agent
      t.rename :resolutionWidth, :resolution_width
      t.rename :resolutionHeight, :resolution_height
    end
  end
end
