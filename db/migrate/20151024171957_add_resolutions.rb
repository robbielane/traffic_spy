class AddResolutions < ActiveRecord::Migration
  def change
    remove_column :payloads, :resolution_width, :string
    remove_column :payloads, :resolution_height, :string
    create_table :resolutions do |t|
      t.string :width
      t.string :height
    end
    add_column :payloads, :resolution_id, :integer
  end
end
