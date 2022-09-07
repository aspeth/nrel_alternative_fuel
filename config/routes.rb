Rails.application.routes.draw do
  get '/', to: 'landing#index'

  resources :stations do
    collection do
      get 'list'
    end
  end
  
  get '/stations', to: 'stations#index'

end
