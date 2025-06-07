class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json

  # GET /users/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    
    if resource.errors.empty?
      sign_in(resource, store: false)

      render json: {
        message: 'Email confirmed successfully',
        user: {
          id: resource.id,
          email: resource.email,
          name: resource.name,
          confirmed_at: resource.confirmed_at
        }
      }, status: :ok
    else
      render json: {
        message: 'Email confirmation failed',
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /users/confirmation
  # Body: { "user": { "email": "user@example.com" } }
  def create
    self.resource = resource_class.find_by(email: resource_params[:email])
    
    if resource&.confirmed?
      render json: {
        message: 'Email was already confirmed'
      }, status: :ok
    elsif resource&.persisted?
      SendConfirmationEmailJob.perform_later(resource.id)
      render json: {
        message: 'Confirmation instructions sent to your email'
      }, status: :ok
    else
      render json: {
        message: 'Email address not found',
        errors: ['Email address not found']
      }, status: :unprocessable_entity
    end
  end

  private

  def resource_params
    params.require(:user).permit(:email)
  end
end 