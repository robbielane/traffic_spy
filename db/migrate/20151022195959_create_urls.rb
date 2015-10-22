class CreateUrls < ActiveRecord::Migration
  def change
    remove_column :payloads, :url, :string
    create_table :urls do |t|
      t.string :path
    end
    add_column :payloads, :url_id, :integer
  end
end
