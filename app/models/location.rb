class Location < ApplicationRecord
  # https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html
  has_many :stations, autosave: true
end
