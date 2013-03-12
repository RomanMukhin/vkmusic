require 'logged_in_constraint'

VkontakteOnRails::Application.routes.draw do
  root to: 'main#index', constraints: LoggedInConstraint.new
  root to: 'sessions#new'
  
  resources :songs do
    post "/sort"=> "songs#sort", on: :collection
  end
  
  resources :lists
  post '/main/search_my_music' => "main#search_my_music", as: "search_my_music"
  post '/main/download' => "main#download", as: "search_download"
  post '/song/:id/download'=> "songs#download", as: "download"
  get 'callback'=> 'sessions#callback'
  delete 'logout'=> 'sessions#destroy', as: "logout"
  match '/search'=> "main#search", as: "search"
  
end
