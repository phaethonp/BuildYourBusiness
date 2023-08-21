class CreateEscrows < ActiveRecord::Migration[7.0]
  def change
    create_table :escrows do |t|
      t.decimal :amount
      t.string :status
      t.references :contract, null: false, foreign_key: true

      t.timestamps
    end
  end
end
