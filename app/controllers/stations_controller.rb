class StationsController < ApplicationController
  def index
    @stations = NRELFacade.get_stations(params[:zipcode])
  end

  def list
    stations = Station.includes(:location).order("#{params[:column]} asc")
    render(partial: 'stations', locals: {stations: stations})
  end
end 