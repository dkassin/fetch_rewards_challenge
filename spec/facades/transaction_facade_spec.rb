require 'rails_helper'

RSpec.describe TransactionFacade, type: :facade do
  before(:each) do
    @@transactions = []
  end
  context 'class methods' do
    describe '::add_transaction' do
      it 'should return a transaction object' do
        data =
        {
          "payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"
        }
        transaction = TransactionFacade.add_transactions(@@transactions, data)
        expect(transaction.last).to be_a(Transaction)
      end
    end

    describe '::sort_transactions' do
      it 'should sort transactions by date' do
        data = {"payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"}
        data_2 = { "payer": "UNILEVER", "points": 200, "timestamp": "2020-10-31T11:00:00Z" }
        data_3 = { "payer": "DANNON", "points": -200, "timestamp": "2020-10-31T15:00:00Z" }

        array_of_transactions = [data, data_2, data_3]

        array_of_transactions.each do |transaction|
          TransactionFacade.add_transactions(@@transactions, transaction)
        end

        sorted_transactions = TransactionFacade.sort_transactions(@@transactions)

        expect(sorted_transactions[0].payer).to eq("UNILEVER")
        expect(sorted_transactions[0].points).to eq(200)

        expect(sorted_transactions[1].payer).to eq("DANNON")
        expect(sorted_transactions[1].points).to eq(-200)

        expect(sorted_transactions[2].payer).to eq("DANNON")
        expect(sorted_transactions[2].points).to eq(1000)
      end
    end
    describe '::spend_points' do
      it 'return a hash of where points were spent' do
        data = {"payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"}
        data_2 = { "payer": "UNILEVER", "points": 200, "timestamp": "2020-10-31T11:00:00Z" }
        data_3 = { "payer": "DANNON", "points": -200, "timestamp": "2020-10-31T15:00:00Z" }
        data_4 = { "payer": "MILLER COORS", "points": 10000, "timestamp": "2020-11-01T14:00:00Z" }
        data_5 = { "payer": "DANNON", "points": 300, "timestamp": "2020-10-31T10:00:00Z" }

        array_of_transactions = [data, data_2, data_3, data_4, data_5]

        array_of_transactions.each do |transaction|
          TransactionFacade.add_transactions(@@transactions, transaction)
        end

        points = 5000
        spent_points_hash = TransactionFacade.spend_points(@@transactions, points)

        expected_response = {"DANNON"=>-100, "UNILEVER"=>-200, "MILLER COORS"=>-4700}

        expect(spent_points_hash).to eq(expected_response)
      end
    end

    describe '::update_transactions' do
      it 'add inverse transactions for every point spent to transactions sorted by date on original transaction' do

        data = {"payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"}
        data_2 = { "payer": "UNILEVER", "points": 200, "timestamp": "2020-10-31T11:00:00Z" }

        array_of_transactions = [data, data_2]

        array_of_transactions.each do |transaction|
          TransactionFacade.add_transactions(@@transactions, transaction)
        end

        points = 1200
        updated_transactions = TransactionFacade.update_transactions(@@transactions, points)

        expect(updated_transactions[0].payer).to eq(data_2[:payer])
        expect(updated_transactions[0].points).to eq(data_2[:points])
        expect(updated_transactions[1].payer).to eq(data_2[:payer])
        expect(updated_transactions[1].points).to eq(data_2[:points]*-1)

        expect(updated_transactions[2].payer).to eq(data[:payer])
        expect(updated_transactions[2].points).to eq(data[:points])
        expect(updated_transactions[3].payer).to eq(data[:payer])
        expect(updated_transactions[3].points).to eq(data[:points]*-1)
      end
    end

    describe '::new_object' do
      it 'helper method returns a hash to be able to use as attributes in new transaction object' do
        payer = "DANNON"
        points = 1000
        time = "2020-11-02T14:00:00Z"

        hash = TransactionFacade.new_object(payer, points, time)

        expected_result = {
                            payer: payer,
                            points: points,
                            timestamp: time
                          }

        expect(hash).to eq(expected_result)
      end
    end

    describe '::point_balance' do
      it 'returns a hash of the point balance' do
        data = {"payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"}
        data_2 = { "payer": "UNILEVER", "points": 200, "timestamp": "2020-10-31T11:00:00Z" }
        data_3 = { "payer": "DANNON", "points": -200, "timestamp": "2020-10-31T15:00:00Z" }
        data_4 = { "payer": "MILLER COORS", "points": 10000, "timestamp": "2020-11-01T14:00:00Z" }
        data_5 = { "payer": "DANNON", "points": 300, "timestamp": "2020-10-31T10:00:00Z" }

        array_of_transactions = [data, data_2, data_3, data_4, data_5]

        array_of_transactions.each do |transaction|
          TransactionFacade.add_transactions(@@transactions, transaction)
        end

        points = 5000
        TransactionFacade.spend_points_route(@@transactions, points)

        expected_response = {"DANNON" => 1000,"UNILEVER" => 0,"MILLER COORS" => 5300}

        expect(TransactionFacade.point_balance(@@transactions)).to eq(expected_response)
      end
    end
  end
end
