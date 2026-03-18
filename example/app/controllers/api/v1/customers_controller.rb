module Api
  module V1
    class CustomersController < ActionController::API
      def index
        render json: { action: 'index', controller: 'customers' }
      end

      def create
        render json: { action: 'create', controller: 'customers' }
      end

      def show
        render json: { action: 'show', controller: 'customers', id: params[:id] }
      end

      def update
        render json: { action: 'update', controller: 'customers', id: params[:id] }
      end

      def destroy
        render json: { action: 'destroy', controller: 'customers', id: params[:id] }
      end
    end
  end
end
