class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.references :user, index: true, foreign_key: true
      t.string :cname
      t.float :campaigndailybudget
      t.string :status

      t.timestamps null: false
    end
    add_index :campaigns, [:user_id, :cname], :unique => true
  end
end