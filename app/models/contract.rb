
# Contract has at least one milestone that defines the task
# we define the Contract model with attributes for each customizable module of the contract
# We also set up associations with the Client and Freelancer models 
# we attach a file for the signed contract
# Add associations to the payment and escrow models

class Contract < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :freelancer, class_name: 'User'
  has_one :payment
  has_one :escrow
  has_one_attached :signed_contract
  has_many :milestones
  has_many :change_orders

  # Attributes for the customizable modules of the contract
  attr_accessor :title, :effective_date, :project_description, :scope_of_work, :payment_terms, :deadlines, :confidentiality, :intellectual_property, :communication, :dispute_resolution, :termination, :governing_law, :signed_date

  # Validations for the presence of the attributes
  validates :title, presence: true
  validates :effective_date, presence: true
  validates :project_description, presence: true
  validates :scope_of_work, presence: true
  validates :payment_terms, presence: true
  validates :deadlines, presence: true
  validates :confidentiality, presence: true
  validates :intellectual_property, presence: true
  validates :communication, presence: true
  validates :dispute_resolution, presence: true
  validates :termination, presence: true
  validates :governing_law, presence: true
  validates :signed_date, presence: true
end
