class ChangeColumnOsInUserAgents < ActiveRecord::Migration
  def change
    rename_column :user_agent, :OS, :os
  end
end
