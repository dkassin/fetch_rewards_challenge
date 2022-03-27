class Api::V1::UsersController < ApplicationController
  @@transactions = []
  @@point_balance = {}
  def add_transactions
    transaction = TransactionFacade.add_transaction(payer_params)
    @@transactions << transaction
    @@transactions = TransactionFacade.sort_transactions(@@transactions)
    @@point_balance = TransactionFacade.add_to_point_balance(transaction, @@point_balance)
  end

  def spend_points
    points = params[:points]
    spent_points = TransactionFacade.spend_points(@@transactions, points)
    @@point_balance = TransactionFacade.update_balance(@@point_balance, spent_points)
    @@transactions = TransactionFacade.update_transactions(@@transactions, points)
  end

  def points_balance
    @@point_balance
  end
end

private

  def payer_params
    params.permit(:payer, :points, :timestamp)
  end
