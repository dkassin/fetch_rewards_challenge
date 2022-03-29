require 'rails_helper'
RSpec.describe 'payer API' do
  before(:each) do
    @@transactions = []
  end
  it 'adds a single transactions for a specific payer and date' do
    data =
    {
      "payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z"
    }
    headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
    post '/api/v1/users/add_transactions', headers: headers, params: JSON.generate(data)

    expect(response).to be_successful
    expect(response.status).to eq(204)
  end

  it 'adds a single transactions for a specific payer and date' do
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
  end

  it 'spends points on transaction and returns the spending points' do
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

    expected_response = [
                          { "payer": "DANNON", "points": -100 },
                          { "payer": "UNILEVER", "points": -200 },
                          { "payer": "MILLER COORS", "points": -4700 }
                        ]

    expect(response).to be_successful
    expect(response.status).to eq(200)

    expect(spend_response).to be_a Array
    spend_response.each do |spend|
      expect(spend).to be_a Hash
      expect(spend).to have_key(:payer)
      expect(spend).to have_key(:points)
    end

    expect(spend_response).to eq(expected_response)
    # This response not having comma's for the integers is the only thing not identical to the fetch_rewards_challenge
    ## I was unable to get the integers to properly add commas in rails and not be a string. The string conversion was
    ### misintrepreting the value of the integer.
  end

  it 'A subsequent get request after a spend call returns a point balance response' do
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

    expected_response = { "DANNON" => 1000, "UNILEVER" => 0, "MILLER COORS" => 5300}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    expect(point_balance).to be_a Hash

    expect(point_balance).to eq(expected_response)
  end
end
