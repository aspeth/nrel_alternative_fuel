module StationsHelper
  def sort_link(column, label)
    link_to(label, list_stations_path(column: column))
  end
end