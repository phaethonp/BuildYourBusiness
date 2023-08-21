# 1. Create a ContractTemplate model
#       This model will represent the standard contract terms.
#       Add attributes for each module that can be customized (e.g., scope of work, payment terms, deadlines).
# 2. Create a template in your application

#       Create a template file with placeholders for the customizable modules.
#       Use a templating engine like ERB to dynamically replace the placeholders with the customized terms.
#  3.Generate a Contract instance from the template

#       3.1 When a user creates a contract, load the ContractTemplate and replace the placeholders with the user's customized terms.
#       3.2 Save the generated contract as an instance of the Contract model.


# app/models/contract_template.rb
class ContractTemplate < ApplicationRecord
    # Add attributes for each customizable module
    attr_accessor :scope_of_work_template, :payment_terms_template, :deadlines_template
  end
  
  # app/controllers/contracts_controller.rb
  class ContractsController < ApplicationController
    def new
      @contract_template = ContractTemplate.first
      @contract = Contract.new
    end
  
    def create
      @contract = Contract.new(contract_params)
      if @contract.save
        # Generate the contract from the template
        contract_text = generate_contract(@contract)
        @contract.update(text: contract_text)
        redirect_to @contract
      else
        render :new
      end
    end
  
    private
  
    def contract_params
      params.require(:contract).permit(:scope_of_work, :payment_terms, :deadlines)
    end
  
    def generate_contract(contract)
      # Load the contract template
      template = File.read(Rails.root.join('app', 'views', 'contracts', '_template.erb'))
  
      # Replace the placeholders with the user's customized terms
      ERB.new(template).result(binding)
    end
  end
  
  # app/views/contracts/_template.erb
  <%= @contract_template.scope_of_work_template %>
  <%= @contract.scope_of_work %>
  
  <%= @contract_template.payment_terms_template %>
  <%= @contract.payment_terms %>
  
  <%= @contract_template.deadlines_template %>
  <%= @contract.deadlines %>
  

  # Create a migration to add the template columns to the ContractTemplate table:

  class AddTemplateColumnsToContractTemplates < ActiveRecord::Migration[6.0]
    def change
      add_column :contract_templates, :scope_of_work_template, :text
      add_column :contract_templates, :payment_terms_template, :text
      add_column :contract_templates, :deadlines_template, :text
    end
  end

  # Update the ContractTemplate model to include the new columns:

  class ContractTemplate < ApplicationRecord
    attr_accessor :scope_of_work_template, :payment_terms_template, :deadlines_template
  end
  

  
  # # Update the ContractsController to use the template from the database:

  def generate_contract(contract)
    # Load the contract template from the database
    @contract_template = ContractTemplate.first
  
    # Replace the placeholders with the user's customized terms
    ERB.new(template).result(binding)
  end

  # Create a form to allow users to update the template
  <%= form_for @contract_template do |f| %>
    <div class="field">
      <%= f.label :scope_of_work_template %><br>
      <%= f.text_area :scope_of_work_template %>
    </div>
    <div class="field">
      <%= f.label :payment_terms_template %><br>
      <%= f.text_area :payment_terms_template %>
    </div>
    <div class="field">
      <%= f.label :deadlines_template %><br>
      <%= f.text_area :deadlines_template %>
    </div>
    <div class="actions">
      <%= f.submit %>
    </div>
  <% end %>

  
  
  
  

  