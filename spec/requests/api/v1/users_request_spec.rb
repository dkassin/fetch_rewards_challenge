require 'rails_helper'
RSpec.describe 'payer API' do
  it 'adds a single transactions for a specific payer and date' do
    @@transactions = []
    @@point_balance = {}
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
    @@point_balance = {}
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

  it 'spends points on transaction and returns the spending points' do
    @@transactions = []
    @@point_balance = {}
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

    spend_response = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(response.status).to eq(200)

    expect(spend_response).to be_a Array
    spend_response.each do |spend|
      expect(spend).to be_a Hash
      expect(spend).to have_key(:payer)
      expect(spend).to have_key(:points)
    end

    expect(spend_response[0][:payer]).to eq("DANNON")
    expect(spend_response[0][:points]).to eq(-100)

    expect(spend_response[1][:payer]).to eq("UNILEVER")
    expect(spend_response[1][:points]).to eq(-200)

    expect(spend_response[2][:payer]).to eq("MILLER COORS")
    expect(spend_response[2][:points]).to eq(-4700)
  end

  it 'A subsequent get request after a spend call returns a point balance response' do
    @@transactions = []
    @@point_balance = {}
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

    headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
    get "/api/v1/users/points_balance", headers: headers

    point_balance = JSON.parse(response.body, symbolize_names: false)

    expect(response).to be_successful
    expect(response.status).to eq(200)

    expect(point_balance).to be_a Hash

    expect(point_balance).to have_key("DANNON")
    expect(point_balance["DANNON"]).to eq(1000)

    expect(point_balance).to have_key("UNILEVER")
    expect(point_balance["UNILEVER"]).to eq(0)

    expect(point_balance).to have_key("MILLER COORS")
    expect(point_balance["MILLER COORS"]).to eq(5300)
  end
end
