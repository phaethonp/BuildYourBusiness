class User < ApplicationRecord
  # ... other attributes and validations ...
  validates :stripe_account_id, presence: true

  # New associations
  has_many :contracts_as_client, class_name: 'Contract', foreign_key: 'client_id'
  has_many :contracts_as_freelancer, class_name: 'Contract', foreign_key: 'freelancer_id'

  # New methods to check user role
  def client?
    role == 'client'
  end

  def freelancer?
    role == 'freelancer'
  end
end
