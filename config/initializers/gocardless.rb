gc_payment_method = Spree::PaymentMethod.find_by_name("GoCardless")

GoCardless.account_details = {
  :app_id      => gc_payment_method.preferred_app_id.to_s,
  :app_secret  => gc_payment_method.preferred_app_secret.to_s,
  :token       => gc_payment_method.preferred_token.to_s,
  :merchant_id => gc_payment_method.preferred_merchant_id.to_s
}

if gc_payment_method.preferred_test_mode and gc_payment_method.preferred_server == 'test'
  puts "Gocardless is in sandbox mode"
  GoCardless.environment = :sandbox
end
puts "GoCardless has been initialized"