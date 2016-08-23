class ChangeNameOfUserAgentToUserAgents < ActiveRecord::Migration
  def change
    rename_table("user_agent", "user_agents")
  end
end
