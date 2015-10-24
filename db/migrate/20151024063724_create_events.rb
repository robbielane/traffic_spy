class CreateEvents < ActiveRecord::Migration
  def change
    remove_column :payloads, :event_name, :string
    create_table :events do |t|
      t.string :event_name
    end
    add_column :payloads, :event_id, :integer
  end
end
