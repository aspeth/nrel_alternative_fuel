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
      stations = NRELService.get_stations(location_string)

      stations.map do |station|
        location.stations << Station.create!(name: station[:station_name], address: "#{station[:street_address]} #{station[:city]}, #{station[:state]} #{station[:zip]}", location_id: location.id, access_code: station[:access_code])
      end

      location.save!
    end

    location.stations
  end
end
