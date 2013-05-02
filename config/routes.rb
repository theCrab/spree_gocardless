Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  get '/gocardless_callback' => 'gocardless#callback', :as => 'gocardless_callback'
  post '/gocardless_webhook' => 'gocardless#webhook', :as => 'gocardless_webhook'
end

# Spree::Core::Engine.routes.prepend do

# end