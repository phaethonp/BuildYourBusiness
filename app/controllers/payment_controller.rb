# app/controllers/payments_controller.rb
class PaymentsController < ApplicationController
    def create
      @payment = Payment.new(payment_params)
      if @payment.save
        StripeService.create_charge(@payment)
        # ... other payment handling steps ...
      else
        render :new
      end
    end
  end
  