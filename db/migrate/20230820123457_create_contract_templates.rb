class CreateContractTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :contract_templates do |t|
      t.string :name # Add a name column
      t.timestamps
    end
  end
end
