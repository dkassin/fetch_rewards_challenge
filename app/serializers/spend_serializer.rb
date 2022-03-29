class SpendSerializer
  def self.spend_serializer(spend_response)
    spend_response.map do |transaction|
          {
            "payer": transaction[0],
            "points": transaction[1]
          }
      end
  end
end
