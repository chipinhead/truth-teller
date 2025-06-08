module Api
    module V1
      class ClientsController < ApplicationController
        before_action :authenticate_user!

        def index
          @clients = Client.all
          render json: @clients
        end

        def create
          @client = Client.new(client_params)
          @client.created_user = current_user
          if @client.save
            render json: @client, status: :created
          else
            render json: @client.errors, status: :unprocessable_entity
          end
        end

        private

        def client_params
          params.require(:client).permit(:name)
        end
      end
    end
end
