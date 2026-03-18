module Api
  module V1
    module Customers
      class UncontactedController < ActionController::API
        def index
          render json: { action: 'index', controller: 'customers/uncontacted' }
        end

        def create
          render json: { action: 'create', controller: 'customers/uncontacted' }
        end

        def show
          render json: { action: 'show', controller: 'customers/uncontacted', id: params[:id] }
        end

        def update
          render json: { action: 'update', controller: 'customers/uncontacted', id: params[:id] }
        end

        def destroy
          render json: { action: 'destroy', controller: 'customers/uncontacted', id: params[:id] }
        end
      end
    end
  end
end
