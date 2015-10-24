class CreateUserAgents < ActiveRecord::Migration
  def change
    remove_column :payloads, :user_agent, :string
    create_table :agents do |t|
      t.string :browser
      t.string :platform
    end
    add_column :payloads, :agent_id, :integer
  end
end
