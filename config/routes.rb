Rails.application.routes.draw do
  get '/', to: 'landing#index'

  get '/stations', to: 'stations#index'
end
