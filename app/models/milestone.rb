class Milestone < ApplicationRecord
  belongs_to :contract
  belongs_to :change_order, optional: true
  
  # Attributes for the milestone details
  attr_accessor :deliverable, :due_date, :payment
  
  # Validations for the presence of the attributes
  validates :deliverable, presence: true
  validates :due_date, presence: true
  validates :payment, presence: true, numericality: { greater_than: 0 }
end
