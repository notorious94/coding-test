class CreateCampaign < ActiveRecord::Migration[6.1]
  def change
    create_table :campaigns do |t|
      t.string :name, null: false, unique: true
      t.string :image
      t.string :sector, null: false
      t.string :country, null: false
      t.integer :creator_id, null: false
      t.decimal :target_amount, precision: 15, scale: 2, default: 0.0
      t.decimal :investment_multiple, precision: 15, scale: 2, default: 0.0
      t.timestamps
    end
  end
end
