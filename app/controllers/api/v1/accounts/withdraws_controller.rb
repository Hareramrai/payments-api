# frozen_string_literal: true

class Api::V1::Accounts::WithdrawsController < Api::BaseController
  before_action :authorize_request

  def create
    Accounts::WithdrawService.call(
      account: account, amount: withdraw_params[:amount],
      description: withdraw_params[:description]
    )

    render json: account
  end

  private

    def account
      @account ||= current_user.accounts.find(params[:account_id])
    end

    def withdraw_params
      params
        .require(:withdraw)
        .permit(:amount, :description)
    end
end
