class UsersController < Devise::RegistrationsController
    before_action :get_token,only:[:new]
    before_action :pay,only:[:create]
    before_action :set_plan_session,only:[:new]
    
    def create
      build_resource(merge_params)
      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          byebug
          if pay() 
            respond_with resource, location: after_sign_up_path_for(resource)   
          else
            resource.destroy
            flash[:error] = "Transaction failed.Please try again"
            redirect_back(fallback_location: root_path)
            return 
          end
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        get_token()
        render 'new'
      end
    end

    private
    
    def get_token
       @client_token = Braintree::ClientToken.generate
    end
    
    
    def pay
        nonce_from_the_client = params[:user][:checkout_form][:payment_method_nonce]
        result = Braintree::Transaction.sale(
         :amount => set_price(), #this is currently hardcoded
         :payment_method_nonce => nonce_from_the_client,
         :options => {
            :submit_for_settlement => true
          }
         )
      
        if result.success?
            return true
        else
            return false
        end
    end
    
    def sign_up_params
        params.require(:user).permit(:checkout_form,:email,:password,:password_confirmation)
    end
    
    def merge_params
      sign_up_params.merge({plan: session[:plan].to_i})
    end
    
    def set_plan_session
      if params[:plan] == 'premium'
        session[:plan] = 0
      elsif params[:plan] == 'amaze'
        session[:plan] = 1
      end  
    end
    
    def set_price
      price = { 0 => "10.00",1 =>"20.00"}
      case session[:plan]
      when 0
        return price[0]
      when 1
        return price[1]
      end
    end
    
end