class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      # Trigger the user registered event
      ActiveSupport::Notifications.instrument('user.registered', user: resource)
      
      render json: { message: 'Signed up.', user: resource }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Override to not sign in automatically after registration
  # skip confirmation email sending
  def sign_up(resource_name, resource)
    resource.skip_confirmation_notification!
  end
end 