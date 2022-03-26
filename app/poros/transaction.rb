class Transaction
  attr_reader :payer, :points, :time

  def initialize(data)
    @payer = data[:payer]
    @points = data[:points]
    @time = DateTime.parse(data[:timestamp])
  end
end
