class CreateAdgroups < ActiveRecord::Migration
  def change
    create_table :adgroups do |t|
      t.references :campaign, index: true, foreign_key: true
      t.string :aname
      t.float :maxcpc
      t.string :headline
      t.text :description1
      t.text :description2
      t.string :displayurl
      t.string :finalurl
      t.string :status

      t.timestamps null: false
    end
    add_index :adgroups, [:campaign_id, :aname], :unique => true
  end
end