class NREL::Service
  def self.get_stations(location_string)
    location = Location.find_or_create_by(location_string: location_string)

    if location.stations.empty?
      stations = NREL::ApiClient.get_stations(location_string)[:fuel_stations]

      stations.map do |station|
        location.stations << Station.create!(name: station[:station_name], address: "#{station[:street_address]} #{station[:city]}, #{station[:state]} #{station[:zip]}", location_id: location.id, access_code: station[:access_code])
      end
      
      location.save!
    end

    location.stations
  end
end