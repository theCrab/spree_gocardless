module Spree
  class PaymentMethod::Gocardless < PaymentMethod
    attr_accessible :preferred_app_id, :preferred_app_secret, :preferred_token, :preferred_merchant_id, :preferred_server, :preferred_test_mode

    preference :app_id, :string
    preference :app_secret, :string
    preference :token, :string
    preference :merchant_id, :string

    preference :server, :string, default: 'test'
    preference :test_mode, :boolean, default: true

    def payment_profiles_supported?
      false
    end

    def actions
      %w{capture void}
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end
  end
end