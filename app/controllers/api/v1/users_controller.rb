class Api::V1::UsersController < ApplicationController
  @@transactions = []
  def add_transactions
    @@transactions << TransactionFacade.add_transaction(payer_params)
  end

  def spend_points
    points = params[:points]
    sorted_transaction = TransactionFacade.sort_transactions(@@transactions)
    x = TransactionFacade.spend_points(sorted_transaction, points)
  end

  def points_balance

  end
end

private

  def payer_params
    params.permit(:payer, :points, :timestamp)
  end
