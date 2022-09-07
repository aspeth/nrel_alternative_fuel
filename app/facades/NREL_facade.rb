class NRELFacade
  def self.get_stations(location_string)
    location = Location.find_or_create_by(location_string: location)

    if location.stations.any?
      location.stations
    else
      stations = NRELService.get_stations(location_string)

      stations.map do |station|
        Station.create!(name: station[:station_name], address: "#{station[:street_address]} #{station[:city]}, #{station[:state]} #{station[:zip]}", location_id: location.id, access_code: station[:access_code])
      end
      
      location.stations = stations
      location.save!
    end

  end
end