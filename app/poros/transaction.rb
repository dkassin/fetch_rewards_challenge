class Transaction
  attr_reader :payer, :points, :time

  def initialize(data)
    @payer = data[:payer]
    @points = data[:points]
    @time = data[:timestamp]
  end
end
