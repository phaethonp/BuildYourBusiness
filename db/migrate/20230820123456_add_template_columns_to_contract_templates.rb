class AddTemplateColumnsToContractTemplates < ActiveRecord::Migration[6.0]
    def change
      add_column :contract_templates, :scope_of_work_template, :text
      add_column :contract_templates, :payment_terms_template, :text
      add_column :contract_templates, :deadlines_template, :text
    end
  end
  