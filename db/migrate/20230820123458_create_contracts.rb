class CreateContracts < ActiveRecord::Migration[7.0]
    def change
      create_table :contracts do |t|
        t.references :client, foreign_key: true
        t.references :freelancer, foreign_key: true
        t.string :scope_of_work
        t.string :payment_terms
        t.string :deadlines
        t.string :confidentiality
        t.string :intellectual_property
        t.string :communication
        t.string :dispute_resolution
        t.string :termination
        t.date :signed_date
  
        t.timestamps
      end
    end
  end
  