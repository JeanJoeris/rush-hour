class ChangeReferrerIdToReferralUrlId < ActiveRecord::Migration
  def change
    change_table :payload_requests do |t|
      t.rename :referrer_id, :referred_by_url_id
    end
  end
end
