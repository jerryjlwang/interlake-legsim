class System::PaymentsController < SystemController
  include ElavonCredentials

  def refund
    payment = User.find( params[:user_id] ).payments.find( params[:id] )

    gateway = ActiveMerchant::Billing::ElavonGateway.new(
      elavon_credentials
    )

    response = gateway.refund(nil, payment.transaction_id)

    if response.success?
      payment.update( status: 'Refunded' )
      redirect_to system_user_path(payment.user), notice: "Payment has been refunded."
    else
      raise StandardError, response.message
    end
  end

  private

  def user_params
    params.require(:payment).permit!
  end
end
