class ContractTemplatesController < ApplicationController
    def edit
      @contract_template = ContractTemplate.find(params[:id])
    end
  end
  