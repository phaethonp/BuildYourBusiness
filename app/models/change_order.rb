class ChangeOrder < ApplicationRecord
    belongs_to :contract
    has_many :milestones
  
    # Attributes for the change order details
    attr_accessor :change_order_number, :original_contract_date, :project_description, :original_contract_amount, :description_of_changes, :impact_on_project_timeline, :impact_on_project_budget, :revised_contract_amount, :payment_terms, :other_relevant_details
  
    # Validations for the presence of the attributes
    validates :change_order_number, presence: true
    validates :original_contract_date, presence: true
    validates :project_description, presence: true
    validates :original_contract_amount, presence: true, numericality: { greater_than: 0 }
    validates :description_of_changes, presence: true
    validates :impact_on_project_timeline, presence: true
    validates :impact_on_project_budget, presence: true
    validates :revised_contract_amount, presence: true, numericality: { greater_than: 0 }
    validates :payment_terms, presence: true
    validates :other_relevant_details, presence: true
  end
  
  # Methods

  # Cancel a milestone
  def cancel_milestone(milestones_id)
    milestone = Milestone.find(milestones_id)
    milestone.update(canceled: true) if milestone
  end 

  # Issue a new milestone
  def issue_new_milestone( deliverable:, due_date:, payemnt: )
    new_milestone = Milestone.new(
        deliverable: deliverable,
        due_date: due_date,
        payment: payment,
        contract: self.contract,
        change_order: self
    )
    new_milestone.save
    # Update the contract attributes affected by the new milestone
    self.contract.update_contract_after_new_milestone
   end
end