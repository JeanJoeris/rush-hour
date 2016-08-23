class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url_path

      t.timestamps null: false
    end
  end
end
