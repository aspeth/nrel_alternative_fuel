# I wouldn't create a `facade` folder nor use that terminology here.
# Generally we want to keep code together in little piles wherever we can, so I would do:
# app/
#   services/
#     nrel/
#       service.rb
#       api_client.rb
# NRELFacade => Nrel::Service
# NRELService => Nrel::ApiClient
#
class NRELFacade
  def self.get_stations(location_string)
    location = Location.find_or_create_by(location_string: location_string)

    if location.stations.empty?
      # I use fetch instead of [:fuel_stations] becuase fetch will throw an error if the key isn't found.
      # I want to see exceptions quickly so I'm not scratching my head later from some NilClass error
      station_data = NRELService.get_stations(location_string).fetch(:fuel_stations)
      cache_stations(location, stations)
    end

    location.stations
  end

  # pull this into its own method to describe what it's doing.
  # Eventually you'd put extra logic here that checked when the
  def cache_stations(location, stations)
    # create the stations in memory first, and then write them to the DB all at once.
    stations = station_data.map do |station|
      Station.new(
        name: station[:station_name],
        address: "#{station[:street_address]} #{station[:city]}, #{station[:state]} #{station[:zip]}",
        access_code: station[:access_code]
      )
    end

    location.stations = station
    location.save!
  end
end
