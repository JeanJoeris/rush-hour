class CreatePayloadrequests < ActiveRecord::Migration
  def change
    create_table :payload_requests do |t|
      t.string :url
      t.datetime :requestedAt
      t.integer :respondedIn
      t.string :referredBy
      t.string :requestType
      t.text :userAgent
      t.string :resolutionWidth
      t.string :resolutionHeight
      t.string :ip

      t.timestamps null: false
    end
  end
end
