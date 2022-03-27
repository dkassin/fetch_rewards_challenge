class Api::V1::UsersController < ApplicationController
  @@transactions = []
  @@point_balance = {}
  def add_transactions
    transaction = TransactionFacade.add_transaction(payer_params)
    @@transactions << transaction
    @@point_balance = TransactionFacade.add_to_point_balance(transaction, @@point_balance)
  end

  def spend_points
    points = params[:points]
    sorted_transaction = TransactionFacade.sort_transactions(@@transactions)
    spent_points = TransactionFacade.spend_points(sorted_transaction, points)
    TransactionFacade.update_balance(@@point_balance, spent_points)
    end

  def points_balance
    @@point_balance
  end
end

private

  def payer_params
    params.permit(:payer, :points, :timestamp)
  end
