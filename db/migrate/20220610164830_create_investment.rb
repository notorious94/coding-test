class CreateInvestment < ActiveRecord::Migration[6.1]
  def change
    create_table :investments do |t|
      t.decimal :amount, precision: 15, scale: 2, default: 0.0
      t.references :campaign, foreign_key: true, null: false
      t.integer :creator_id, null: false
      t.timestamps
    end
  end
end
