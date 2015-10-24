class CreateRequestTypes < ActiveRecord::Migration
  def change
    remove_column :payloads, :request_type, :string
    create_table :request_types do |t|
      t.string :verb
    end
    add_column :payloads, :request_type_id, :integer
  end
end
