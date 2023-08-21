 # app/controllers/contracts_controller.rb
 
 require 'stripe'
 
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


        # Initiate a payment to the escrow account
        Stripe::Transfer.create({
        amount: @contract.payment.amount,
        currency: 'usd',
        destination: @contract.escrow.account_id,
        })
    else
      render :new
    end
  end

  def complete
    @contract = Contract.find(params[:id])
    # ... other contract completion steps ...

    # Release the payment from the escrow account to the freelancer
    Stripe::Transfer.create({
      amount: @contract.escrow.amount,
      currency: 'usd',
      destination: @contract.freelancer.account_id,
    })
  end
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