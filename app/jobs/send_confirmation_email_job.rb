class SendConfirmationEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.send_confirmation_instructions
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "User with ID #{user_id} not found for confirmation email"
  end
end 