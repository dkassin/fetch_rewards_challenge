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

  def self.new_object(payer, points_left, time)
    new_data = {}
    new_data[:payer] = payer
    new_data[:points] = points_left
    new_data[:timestamp] = time
    return new_data
  end

  def self.update_transactions(transactions, points)
    points_started = points
    points_used = 0
    spent_transaction = []
    counter = 0
    transactions.each do |transaction|
      counter += 1
      if (points_started - points_used) <= transaction.points
        points_left = (points_started - points_used)
        left_over = transaction.points - points_left
        points_used += points_left
        new_data = TransactionFacade.new_object(transaction.payer, left_over, transaction.time.to_s)
        transactions << TransactionFacade.add_transaction(new_data)
        transactions.shift(counter)
        return TransactionFacade.sort_transactions(transactions)
      else
        points_used += transaction.points
      end
    end
  end
end
