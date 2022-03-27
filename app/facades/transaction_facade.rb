class TransactionFacade
  def self.add_transaction(params)
      Transaction.new(params)
  end

  def self.add_to_point_balance(transaction, balance)
    updated_balance = balance
    if balance.has_key?(transaction.payer)
      updated_balance[transaction.payer] += transaction.points
    else
      updated_balance[transaction.payer] = transaction.points
    end
    return updated_balance
  end

  def self.update_balance(point_balance, spent_points)
    spent_points.each do |key, value|
      point_balance[key] += value
    end
    return point_balance
  end

  def self.sort_transactions(transactions)
    transactions.sort_by {|transaction| transaction.time}
  end

  def self.spend_points(sorted_transaction, points)
    spent_hash = {}
    points_started = points
    points_used = 0
    sorted_transaction.each do |transaction|
      if (points_started - points_used) <= transaction.points
        points_left = (points_started - points_used)
        points_used += points_left
        if spent_hash.has_key?(transaction.payer)
          spent_hash[transaction.payer] -= points_left
        else
          spent_hash[transaction.payer] = points_left*-1
        end
      else
        points_used += transaction.points
        if spent_hash.has_key?(transaction.payer)
          spent_hash[transaction.payer] -= transaction.points
        else
          spent_hash[transaction.payer] = transaction.points*-1
        end
      end
    end
    spent_hash
  end
end
