class NREL::ApiClient
  URL = "https://developer.nrel.gov/"
  API_KEY = ENV["nrel_api_key"]

  def self.get_stations(location_string)
    with_error_handling do
      connection.get("/api/alt-fuel-stations/v1/nearest", location: location_string)
    end
  end


  private

  def self.connection
    Faraday.new(url: URL, params: { api_key: API_KEY, format: "json" }) do |faraday|
      faraday.use Faraday::Response::RaiseError
    end
  end


  def self.with_error_handling
    response = yield

    JSON.parse(response.body, symbolize_names: true)
    
  rescue Faraday::ForbiddenError => e
    Rails.logger.error("Nrel::ApiClient Error", e.response.body)
    return { error: "There was a problem with your API KEY. Check the application logs." }

  rescue Faraday::ClientError => e
    if e.status == 429
      return { error: "NREL rate limits exceeded. Try again later." }
    else
      Rails.logger.error("Nrel::ApiClient Error", e.response.body)
      return { error: "There was a problem with your request. Check the application logs."}
    end

  rescue Faraday::ServerError => e
    Rails.logger.error("Nrel::ApiClient Error", e.response.body)
    return { error: "The NREL API experienced an unknown server error. Check the application logs for more details."}
  end
end