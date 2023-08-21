class StripeService

    # User Onboarding create Stripe Connected Account
    # Seelect the account type Express
    account = Stripe::Account.create({
        type: 'express', # or 'custom'
        email: user.email,
        business_type: 'individual',
        individual: {
          first_name: user.first_name,
          last_name: user.last_name,
          address: {
            line1: user.address_line1,
            city: user.city,
            state: user.state,
            postal_code: user.postal_code,
            country: user.country
          },
          dob: { # Date of birth
            day: user.dob_day,
            month: user.dob_month,
            year: user.dob_year
          },
          ssn_last_4: user.ssn_last_4, # Last 4 digits of Social Security Number (if applicable)
          phone: user.phone,
          # Other required information
        },
        business_profile: {
          tax_id: user.vat_number # VAT number
        },
        tos_acceptance: {
          date: Time.now.to_i,
          ip: request.remote_ip # Replace with the user's IP address
        }
      })
      
        user.update(stripe_account_id: account.id)
      end
    end


    # Alternative process— Using Stripe Onboarding process
    account_link = Stripe::AccountLink.create({
        account: user.stripe_account_id, # The ID of the connected account
        refresh_url: 'https://example.com/reauth', # Replace with your reauth URL
        return_url: 'https://example.com/return',  # Replace with your return URL
        type: 'account_onboarding'
      })
      
      # Redirect the user to the onboarding flow
      redirect_to account_link.url
      

    # Create SEPA Direct Debit PaymentIntent from Client-to-Freelancer
    def self.create_sepa_payment_intent(client, amount_cents)
      payment_intent = Stripe::PaymentIntent.create({
        payment_method_types: ['sepa_debit'],
        amount: amount_cents,
        currency: 'eur',
        customer: client.stripe_customer_id,
    })

    charge = Stripe::Charge.create({
        amount: payment.amount_cents,
        currency: 'eur',
        customer: payment.client.stripe_customer_id,
        metadata: {
          contract_id: payment.contract_id,
          milestone_id: payment.milestone_id
        }
      })
      payment.update(stripe_charge_id: charge.id)
      



     # Return the client secret for client-side authentication
     payment_intent.client_secret
    end



    # Transfer funds for approved milestone
    def self.release_funds_for_milestone(milestone, freelancer, platform)
      if milestone.status == 'approved'
        transfer = Stripe::Transfer.create({
        amount: milestone.amount_cents,
        currency: 'eur',
        source: platform.stripe_account_id,
        destination: freelancer.stripe_account_id,
        source_transaction: milestone.stripe_charge_id,
      })
      milestone.update(stripe_transfer_id: transfer.id)
    end
  
  
    # Handle payout to freelancer's bank account
    def self.create_payout(freelancer, amount_cents)
      Stripe::Payout.create({
      amount: amount_cents,
      currency: 'eur',
      destination: freelancer.stripe_account_id,
      })
    end



    ---------------------------------
  
    # app/services/stripe_service.rb

    def self.create_charge(payment)
      charge = Stripe::Charge.create({
        amount: payment.amount_cents,
        currency: 'eur',
        customer: payment.client.stripe_customer_id,
      })
      payment.update(stripe_charge_id: charge.id)
    end

  
    def self.release_funds(payment, freelancer, platform)
      transfer = Stripe::Transfer.create({
        amount: payment.amount_cents,
        currency: 'usd',
        source: platform.stripe_account_id, # Explicitly specify the platform's Stripe Connect account as the source of the transfer
        destination: freelancer.stripe_account_id,
        source_transaction: payment.stripe_charge_id,
      })
      payment.update(stripe_transfer_id: transfer.id)
    end


        # app/services/stripe_service.rb
    def self.release_funds_for_milestone(milestone, freelancer, platform)
    if milestone.status == 'approved'
      transfer = Stripe::Transfer.create({
        amount: milestone.amount_cents,
        currency: 'usd',
        source: platform.stripe_account_id,
        destination: freelancer.stripe_account_id,
        source_transaction: milestone.stripe_charge_id,
      })
      milestone.update(stripe_transfer_id: transfer.id)
    end
  end
  

  end
# Contracts Module 

# app/models/contract.rb
class Contract < ApplicationRecord
    has_many :milestones
    has_one :payment
    belongs_to :client, class_name: 'User'
    belongs_to :freelancer, class_name: 'User'
  end
  
  # app/models/milestone.rb
  class Milestone < ApplicationRecord
    belongs_to :contract
  end
  
  # app/models/payment.rb
  class Payment < ApplicationRecord
    belongs_to :contract
  end
  
  # app/models/escrow.rb
  class Escrow < ApplicationRecord
    belongs_to :contract
  end
  
# Contract Factory

class ContractFactory
    def self.create_contract(client, freelancer, terms, milestones_data)
      contract = Contract.create(client: client, freelancer: freelancer, terms: terms)
      milestones_data.each do |milestone_data|
        contract.milestones.create(milestone_data)
      end
      contract
    end
  end
  

# Electronic Signature?

class Contract < ApplicationRecord
    # ...
    attr_accessor :client_signature, :freelancer_signature
    # ...
  end
  
# Create Templates for Standard Contract Terms:

class ContractTemplate < ApplicationRecord
    # Attributes: scope_of_work_template, payment_terms_template, deadlines_template, etc.
  end
  

# Create and Fund Milestones:

class Escrow < ApplicationRecord
    # Attributes: contract_id, milestone_id, amount, status
  end
  

# Work Delivery and Approval:

class Milestone < ApplicationRecord
    # Attributes: name, description, due_date, amount, status
  end
  

# Release Funds for Approved Milestones:

class StripeService
    def self.release_funds_for_milestone(milestone, freelancer, platform)
      if milestone.status == 'approved'
        transfer = Stripe::Transfer.create({
          amount: milestone.amount_cents,
          currency: 'eur',
          source: platform.stripe_account_id,
          destination: freelancer.stripe_account_id,
          source_transaction: milestone.stripe_charge_id,
        })
        milestone.update(stripe_transfer_id: transfer.id)
      end
    end
  end
  