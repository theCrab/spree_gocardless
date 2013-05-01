module SpreeGocardless
  class Engine < Rails::Engine
    require 'spree/core'
    require "gocardless"
    isolate_namespace Spree
    engine_name 'spree_gocardless'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "spree.gateway.payment_methods", after: "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Spree::PaymentMethod::Gocardless

      # Maybe there's a better way of doing this?

      # The info below is provided from Spree Dashboard.

      # Here's not the best place, since it's also run when executing rake commands!
      # payment_method = Spree::PaymentMethod.find_by_name("GoCardless")

      # if payment_method.preferred_test_mode and payment_method.preferred_server == 'test'
      #   puts "Gocardless is in sandbox mode"
      #   GoCardless.environment = :sandbox
      # end
      # if payment_method.preferred_test_mode and payment_method.preferred_server == 'test'
      #   puts "Gocardless is in sandbox mode"
      #   GoCardless.environment = :sandbox
      # end

      GoCardless.account_details = {
        app_id:       GC_APP_ID,
        app_secret:   GC_APP_SEKRET,
        token:        GC_APP_TOKEN,
        merchant_id:  GC_MERCHANT_ID
      }

      puts "GoCardless has been initialized"
    end

    config.to_prepare &method(:activate).to_proc
  end
end
