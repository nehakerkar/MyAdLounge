class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.references :adgroup, index: true, foreign_key: true
      t.string :keyword
      t.string :criteriontype
      t.float :firstpagebid
      t.float :topofpagebid
      t.string :status

      t.timestamps null: false
    end
        add_index :ads, [:adgroup_id, :keyword], :unique => true
  end
end