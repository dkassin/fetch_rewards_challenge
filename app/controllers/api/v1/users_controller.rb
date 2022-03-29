class Api::V1::UsersController < ApplicationController
  @@transactions = []
  def add_transactions
    TransactionFacade.add_transactions(@@transactions, payer_params)
    render status: :no_content
  end

  def spend_points
    spent_points = TransactionFacade.spend_points_route(@@transactions, params[:points])
    render json: SpendSerializer.spend_serializer(spent_points)
  end

  def points_balance
    balance = TransactionFacade.point_balance(@@transactions)
    render json: BalanceSerializer.point_balance_serializer(balance)
  end
end

private

  def payer_params
    params.permit(:payer, :points, :timestamp)
  end
