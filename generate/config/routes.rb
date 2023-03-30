Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'url_shortener', to: 'url_shortener#create'
    end
  end
end
