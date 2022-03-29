require 'rails_helper'

RSpec.describe "transaction object" do
  it 'exists' do
    data =
    {
      "payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"
    }
  transaction = Transaction.new(data)

  expect(transaction).to be_a Transaction
  expect(transaction.payer).to eq("DANNON")
  expect(transaction.points).to eq(1000)
  expect(transaction.time).to eq("2020-11-02T14:00:00Z")
  end
end
