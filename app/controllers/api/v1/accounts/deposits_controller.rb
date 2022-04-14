# frozen_string_literal: true

class Api::V1::Accounts::DepositsController < Api::BaseController
  before_action :authorize_request

  def create
    Accounts::DepositService.call(
      account: account, amount: deposit_params[:amount],
      description: deposit_params[:description]
    )

    render json: account
  end

  private

    def account
      @account ||= current_user.accounts.find(params[:account_id])
    end

    def deposit_params
      params
        .require(:deposit)
        .permit(:amount, :description)
    end
end
