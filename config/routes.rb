Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  match '/gocardless_callback' => 'gocardless#callback', :as => 'gocardless_callback', via => [:get]
  match '/gocardless_webhook' => 'gocardless#webhook', :as => 'gocardless_webhook', via => [:post]
end

# Spree::Core::Engine.routes.prepend do

# end