class CreateUserAgents < ActiveRecord::Migration
  def change
    create_table :user_agent do |t|
      t.string :OS
      t.string :browser

      t.timestamps null: false
    end
  end
end
