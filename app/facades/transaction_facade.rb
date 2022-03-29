class TransactionFacade

  def self.add_transactions(transactions, params)
    transactions << Transaction.new(params)
    @@transactions = TransactionFacade.sort_transactions(transactions)
  end

  def self.sort_transactions(transactions)
    transactions.sort_by {|transaction| transaction.time}
  end

  def self.spend_points_route(transactions,points)
    spent_points = TransactionFacade.spend_points(transactions, points)
    @@transactions  = TransactionFacade.update_transactions(transactions, points)
    return spent_points
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

  def self.update_transactions(transactions, points)
    points_used = 0
    transactions.each do |transaction|
      if (points - points_used) <= transaction.points
        points_left = (points - points_used)
        points_used += points_left
        new_data = TransactionFacade.new_object(transaction.payer, (points_left*-1), transaction.time.to_s)
        transactions << Transaction.new(new_data)
        return TransactionFacade.sort_transactions(transactions)
      else
        new_data = TransactionFacade.new_object(transaction.payer, (transaction.points*-1), transaction.time.to_s)
        transactions << Transaction.new(new_data)
        points_used += transaction.points
      end
    end
  end

  def self.new_object(payer, points_left, time)
    new_data = {}
    new_data[:payer] = payer
    new_data[:points] = points_left
    new_data[:timestamp] = time
    return new_data
  end


  def self.point_balance(transactions)
    point_balance = {}
    transactions.each do |transaction|
      if point_balance.has_key?(transaction.payer)
        point_balance[transaction.payer] += transaction.points
      else
        point_balance[transaction.payer] = transaction.points
      end
    end
    return point_balance
  end









end
