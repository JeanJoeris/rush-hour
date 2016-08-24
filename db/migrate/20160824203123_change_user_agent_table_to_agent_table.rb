class ChangeUserAgentTableToAgentTable < ActiveRecord::Migration
  def change
    rename_table("user_agents", "agents")
  end
end
