class NRELService
  def self.get_stations(location_string)
    conn = Faraday.new("https://developer.nrel.gov/")
    response = conn.get("/api/alt-fuel-stations/v1/nearest?format=json&api_key=#{ENV["nrel_api_key"]}&location=#{location_string}")
    hash_response = JSON.parse(response.body, symbolize_names: :true)[:fuel_stations]
  end
end