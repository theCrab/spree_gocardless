module Spree
  class PaymentMethod::Gocardless < PaymentMethod
    preference :app_id, :string
    preference :app_secret, :string
    preference :token, :string
    preference :merchant_id, :string

    def provider_class
      self.provider || GoCardless
    end

    def redirect_url(order,, opts={})
      opts.merge! self.preferences

    # We'll be billing everyone £10 per month in this example
      opts[:amount]          => 10,
      opts[:interval_unit]   => "month",
      opts[:interval_length] => 1,
      opts[:name]            => "Premium Subscription",
      # Set the user email from the submitted value
      opts[:user] => { :email => params["email"] }

      url = GoCardless.new_subscription_url(url_params)
      redirect_to url
    end
  end
end