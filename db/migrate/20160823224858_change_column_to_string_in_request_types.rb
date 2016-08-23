class ChangeColumnToStringInRequestTypes < ActiveRecord::Migration
  def change
    change_column :request_types, :http_verb, :string
  end
end
