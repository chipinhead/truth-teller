module Api
  module V1
    class UserClientsController < ApplicationController
      before_action :authenticate_user!

      # POST /api/v1/users/:user_id/clients/:client_id
      def create
        user = User.find(params[:user_id])
        client = Client.find(params[:id])
        
        if user.clients.include?(client)
          render json: { message: 'User is already associated with this client' }, status: :ok
        else
          user.clients << client
          render json: { message: 'Client successfully added to user' }, status: :created
        end
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: 'User or Client not found' }, status: :not_found
      end

      # GET /api/v1/users/:user_id/clients
      def index
        user = User.find(params[:user_id])
        render json: user.clients, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
      end
    end
  end
end 