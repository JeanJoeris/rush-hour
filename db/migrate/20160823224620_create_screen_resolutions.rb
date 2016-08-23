class CreateScreenResolutions < ActiveRecord::Migration
  def change
    create_table :screen_resolutions do |t|
      t.string :width
      t.string :height

      t.timestamps null: false
    end
  end
end
