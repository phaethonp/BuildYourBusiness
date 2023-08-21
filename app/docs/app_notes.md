###  Let's create a contract form where users can create a contract using the template

1. Update the Contract Model: Add the new field to the Contract model.<BR>

```
# app/models/contract.rb
class Contract < ApplicationRecord
  has_many :milestones
  belongs_to :client, class_name: 'User'
  belongs_to :freelancer, class_name: 'User'
  # New field
  attr_accessor :legal_jurisdiction
end
```

2. Create a Migration: Generate a migration to add the new field to the contracts table<BR>

```
rails generate migration AddLegalJurisdictionToContracts legal_jurisdiction:string
```

3. Run the Migration: Run the migration to update the database schema.

``` SHELL
rails generate migration AddLegalJurisdictionToContracts legal_jurisdiction:string
```

4. Update the Contracts Controller: Add the new field to the strong parameters in the contracts controller.<BR>

```
# app/controllers/contracts_controller.rb
class ContractsController < ApplicationController
  # ...
  def contract_params
    params.require(:contract).permit(:scope_of_work, :payment_terms, :deadlines, :legal_jurisdiction)
  end
end
```

5. Create the Contract Form: Create a form where users can create a contract using the updated template.<BR>

```
<!-- app/views/contracts/new.html.erb -->
<%= form_for @contract do |f| %>
  <div class="field">
    <%= f.label :scope_of_work %><br>
    <%= f.text_area :scope_of_work, value: @contract_template.scope_of_work_template %>
  </div>
  <div class="field">
    <%= f.label :payment_terms %><br>
    <%= f.text_area :payment_terms, value: @contract_template.payment_terms_template %>
  </div>
  <div class="field">
    <%= f.label :deadlines %><br>
    <%= f.text_area :deadlines, value: @contract_template.deadlines_template %>
  </div>
  <div class="field">
    <%= f.label :legal_jurisdiction %><br>
    <%= f.text_field :legal_jurisdiction %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```

6. Handle Form Submission: When the user submits the form, the create action in the ContractsController will handle the form data and create a new contract in the database.


```
# app/controllers/contracts_controller.rb
class ContractsController < ApplicationController
  # ...
  def create
    @contract = Contract.new(contract_params)
    if @contract.save
      redirect_to @contract, notice: 'Contract was successfully created.'
    else
      render :new
    end
  end
end
```

When the user submits the form, the create action creates a new contract using the strong parameters from the contract_params method. If the contract is successfully saved, the user is redirected to the contract's page. If there are any validation errors, the new view is rendered again.<BR>