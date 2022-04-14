# frozen_string_literal: true

class Api::V1::AccountsController < Api::BaseController
  before_action :authorize_request

  # GET /accounts
  def index
    accounts = paginate Accounts::IndexQuery
               .new(current_user.accounts)
               .call(search_params)

    render json: accounts
  end

  # POST /accounts
  def create
    account = current_user.accounts.create!(account_params)
    render json: account
  end

  def show
    account = current_user.accounts.find(params[:id])
    render json: account
  end

  private

    def account_params
      params
        .require(:account)
        .permit(:title, :iban, :amount, :overdraft_limit)
    end

    def search_params
      params.permit(:title, :iban)
    end
end
