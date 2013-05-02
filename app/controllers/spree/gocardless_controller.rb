class Spree::GocardlessController < Spree::BaseController
  protect_from_forgery :except => [:webhook]
  # To be tested, maybe it's required?
  # ssl_required


  def webhook
    puts "webhook params: #{params.inspect}"
    if GoCardless.webhook_valid?(params[:payload])
       render :text => "true", :status => 200
     else
       render :text => "false", :status => 403
     end
  end


  def callback

    puts "callback params: #{params.inspect}"
    order_no = params[:state]

    # Note. We cannot use user.id if the user didn't login!
    # Maybe it's possible to check some session variables with a temporary id?
    user = spree_current_user
    if user
      @order = Spree::Order.where(:number => order_no).where(:user_id => user.id).first
    else
      @order = Spree::Order.where(:number => order_no).first
    end

    # We confirm to GoCardless we've received their callback
    GoCardless.confirm_resource params


    if @order && @order.present? && correct_order_state

      @order.payment.pend!


      @order.update_attributes({:state => "complete", :completed_at => Time.now}, :without_protection => true)

      # @order.payment.complete!
      # Unset the order id as it's completed.
      session[:order_id] = nil

      # This will also send an confirmation email to the client
      @order.finalize!
      flash[:notice] = I18n.t(:order_processed_successfully)
      flash[:commerce_tracking] = "true"
      redirect_to spree.order_path(@order)
    else
      flash[:error] = "error"
      redirect_to root_path
    end
    return
    # Need to find out how to handle propertly exception
    # rescue GoCardless::ApiError => e
    #   render :text => "Could not confirm new subscription. Details: #{e}"
    # end

  end



  private
    def correct_order_state
      (@order.state == 'payment' || @order.state == 'complete') &&
        @order.payment_method &&
        (@order.payment_method.type == "Spree::PaymentMethod::Gocardless")
    end

end