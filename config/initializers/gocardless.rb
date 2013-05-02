# gc_payment_method = Spree::PaymentMethod.find_by_type("Spree::PaymentMethod::Gocardless")

# if !Rails.env.production? && gc_payment_method.preferred_test_mode && gc_payment_method.preferred_server == 'test'
#   puts "Gocardless is in sandbox mode"
#   GoCardless.environment = :sandbox
# end

# unless gc_payment_method.blank?
#   GoCardless.account_details = {
#     :app_id      => gc_payment_method.preferred_app_id.to_s,
#     :app_secret  => gc_payment_method.preferred_app_secret.to_s,
#     :token       => gc_payment_method.preferred_token.to_s,
#     :merchant_id => gc_payment_method.preferred_merchant_id.to_s
#   }
# end