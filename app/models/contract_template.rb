# app/models/contract_template.rb
class ContractTemplate < ApplicationRecord
    # Add attributes for each customizable module
    attr_accessor :scope_of_work_template, :payment_terms_template, :deadlines_template
  end
  
 
  
  
  