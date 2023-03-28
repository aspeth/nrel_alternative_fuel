class StationsController < ApplicationController
  def index
    @stations = NREL::Service.get_stations(params[:zipcode])
  end

  def list
    stations = Station.includes(:location).order("#{params[:column]} #{params[:direction]}")
    render(partial: 'stations', locals: {stations: stations})
  end
end 