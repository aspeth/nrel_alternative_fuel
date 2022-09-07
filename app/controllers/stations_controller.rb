class StationsController < ApplicationController
  def index
    conn = Faraday.new("https://developer.nrel.gov/")
    response = conn.get("/api/alt-fuel-stations/v1/nearest?format=json&api_key=#{ENV["nrel_api_key"]}&location=#{params[:zipcode]}")
    hash_response = JSON.parse(response.body, symbolize_names: :true)
    
    @stations = hash_response[:fuel_stations]
  end

  def list
    stations = Station.includes(:location).order("#{params[:column]}")
    render(partial: 'stations', locals: {stations: stations})
  end
end 