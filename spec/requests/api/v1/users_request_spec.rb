require 'rails_helper'
RSpec.describe 'payer API' do
  it 'adds a single transactions for a specific payer and date' do
    @@transactions = []
    data =
    {
      "payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"
    }
    headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
    post '/api/v1/users/add_transactions', headers: headers, params: JSON.generate(data)

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(@@transactions.count).to eq(1)
  end

  it 'adds a single transactions for a specific payer and date' do
    @@transactions = []
    data = {"payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"}
    data_2 = { "payer": "UNILEVER", "points": 200, "timestamp": "2020-10-31T11:00:00Z" }
    data_3 = { "payer": "DANNON", "points": -200, "timestamp": "2020-10-31T15:00:00Z" }
    data_4 = { "payer": "MILLER COORS", "points": 10000, "timestamp": "2020-11-01T14:00:00Z" }
    data_5 = { "payer": "DANNON", "points": 300, "timestamp": "2020-10-31T10:00:00Z" }

    array_of_transactions = [data, data_2, data_3, data_4, data_5]

    array_of_transactions.each do |transaction|
      headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
      post '/api/v1/users/add_transactions', headers: headers, params: JSON.generate(transaction)

      expect(response).to be_successful
      expect(response.status).to eq(204)
    end
    expect(@@transactions.count).to eq(5)
  end

  it 'adds a single transactions for a specific payer and date' do
    @@transactions = []
    data = {"payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"}
    data_2 = { "payer": "UNILEVER", "points": 200, "timestamp": "2020-10-31T11:00:00Z" }
    data_3 = { "payer": "DANNON", "points": -200, "timestamp": "2020-10-31T15:00:00Z" }
    data_4 = { "payer": "MILLER COORS", "points": 10000, "timestamp": "2020-11-01T14:00:00Z" }
    data_5 = { "payer": "DANNON", "points": 300, "timestamp": "2020-10-31T10:00:00Z" }

    array_of_transactions = [data, data_2, data_3, data_4, data_5]

    array_of_transactions.each do |transaction|
      headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
      post '/api/v1/users/add_transactions', headers: headers, params: JSON.generate(transaction)
    end

    spend =  { "points": 5000 }

    headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
    post '/api/v1/users/spend_points', headers: headers, params: JSON.generate(spend)

    expect(response).to be_successful
    expect(response.status).to eq(204)
  end
end
