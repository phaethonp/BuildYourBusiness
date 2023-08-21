class RegistrationsController < ApplicationController
    def create
      @user = User.new(user_params)
      if @user.save
        StripeService.create_account(@user)
        # ... other registration steps ...
      else
        render :new
      end
    end
  end
  