Spree::CheckoutController.class_eval do
  before_filter :redirect_to_gocardless_if_needed, :only => [:update]

  def edit
    @order = current_order(true)
    puts "current order:#{@order.inspect}"
  end

  def redirect_to_gocardless_if_needed
    puts "redirect_to_gocardless params: #{params.inspect}"
    return unless params[:state] == "payment"

    selected_method_id = params[:order][:payments_attributes].first[:payment_method_id]
    @payment_method = Spree::PaymentMethod.find(selected_method_id)

    if @payment_method && @payment_method.kind_of?(Spree::PaymentMethod::Gocardless)
      puts "Update attributes: #{object_params}"
      @order.update_attributes(object_params)
      gocardless_url = gocardless_new_bill_url
      puts "Gocardless url: #{gocardless_url}"
      redirect_to gocardless_url
    end
  end
private

  def gocardless_new_bill_url
    GoCardless.new_bill_url(
      :amount => @order.total.to_s,
      # :name => "This is a title, do we need it???",
      # NOTE, we need to pass the order number in "state" parameter.
      # GoCardless will send back this number during its callback procedure
      :state  => @order.number.to_s,
      :user   => {
        "first_name"       => @order.bill_address.firstname,
        "last_name"        => @order.bill_address.firstname,
        "email"            => @order.email,
        "billing_address1" => @order.bill_address.address1,
        "billing_address2" => @order.bill_address.address2,
        "billing_town"     => @order.bill_address.city,
        "billing_postcode" => @order.bill_address.zipcode
      })
  end
end
