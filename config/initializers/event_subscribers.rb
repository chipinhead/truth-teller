ActiveSupport::Notifications.subscribe('user.registered') do |name, started, finished, unique_id, payload|
  user = payload[:user]
  
  Rails.logger.info "User registered: #{user.email}"
  SendConfirmationEmailJob.perform_later(user.id)
end 