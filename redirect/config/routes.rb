Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'url_shortener/:shortId', to: 'redirect#redirect'
    end
  end
end
