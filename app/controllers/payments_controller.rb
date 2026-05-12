class PaymentsController < ApplicationController
  include ElavonCredentials

  layout 'public'
  skip_before_action :authenticate_user!
  before_action :find_registered_user

  LICENSE_AMOUNT = 1600

  def elavon
    if @registered_user.has_license?
      confirm_or_send_confirmation_instructions(@registered_user)
      render :has_license
    else
      @payment = { 
        amount: LICENSE_AMOUNT,
        errors: {}
      }
    end
  end

  def elavon_checkout

    if @registered_user.has_license?
      confirm_or_send_confirmation_instructions(@registered_user)
      render :has_license
    else

      gateway = ActiveMerchant::Billing::ElavonGateway.new(
        elavon_credentials
      )

      cc_exp_year = params[:payment][:cc_exp_year].length == 2 ? '20' + params[:payment][:cc_exp_year] : params[:payment][:cc_exp_year]

      # The card verification value is also known as CVV2, CVC2, or CID
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :name               => params[:payment][:cc_name],
        :number             => params[:payment][:cc_number],
        :month              => params[:payment][:cc_exp_month],
        :year               => cc_exp_year,
        :verification_value => params[:payment][:cc_cvc]
      )    

      @payment = { 
        amount:             LICENSE_AMOUNT,
        name:               params[:payment][:cc_name],
        number:             params[:payment][:cc_number],
        exp_month:          params[:payment][:cc_exp_month],
        exp_year:           params[:payment][:cc_exp_year],
        verification_value: params[:payment][:cc_cvc],
        address1:           params[:payment][:cc_address1],
        city:               params[:payment][:cc_city],
        zip:                params[:payment][:cc_zip],
        state:              params[:payment][:cc_state]
      }

      if credit_card.validate.empty?

        response = gateway.purchase(LICENSE_AMOUNT, credit_card,
          {
            :address => {
              address1: params[:payment][:cc_address1],
              city: params[:payment][:cc_city],
              zip: params[:payment][:cc_zip],
              state: params[:payment][:cc_state]
            }
          }
        )

        if response.success?

          @registered_user.payments.create(
            payment_type: 'Evalon',
            amount: LICENSE_AMOUNT,
            processed_at: Time.parse( response.params['txn_time'] ) - 3.hours,
            transaction_id: response.params['txn_id'],
            approval_code: response.params['approval_code'],
            status: 'Paid',
            cc_number: response.params['card_number'],
            test: response.test
          )

          confirm_or_send_confirmation_instructions(@registered_user)
          render :complete
        else

          @registered_user.payments.create(
            payment_type: 'Evalon',
            amount: LICENSE_AMOUNT,
            processed_at: Time.now,
            transaction_id: nil,
            approval_code: nil,
            status: 'Failed',
            unmasked_cc_number: params[:payment][:cc_number],
            details: response.message,
            test: response.test
          )

          @payment[:errors] = {message: response.message}
          render :elavon
        end
    
      else

        @registered_user.payments.create(
          payment_type: 'Evalon',
          amount: LICENSE_AMOUNT,
          processed_at: Time.now,
          transaction_id: nil,
          approval_code: nil,
          status: 'Failed',
          unmasked_cc_number: params[:payment][:cc_number],
          details: credit_card.validate.inspect,
          test: nil
        )

        @payment[:errors] = credit_card.validate
        render :elavon 
      end

    end

  end

  private

  def find_registered_user
    if session[:registered_user_id]
      @registered_user = User.find( session[:registered_user_id] )
    else
      redirect_to '/users/sign_up', notice: "You have not yet registered"
    end
  end

end
