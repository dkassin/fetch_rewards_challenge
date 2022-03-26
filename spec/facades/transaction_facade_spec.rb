require 'rails_helper'

RSpec.describe TransactionFacade, type: :facade do
  context 'class methods' do
    describe '::add_transaction' do
      it 'should return a transaction object' do
        data =
        {
          "payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"
        }
        transaction = TransactionFacade.add_transaction(data)
        expect(transaction).to be_a(Transaction)
      end
    end
  end
end
