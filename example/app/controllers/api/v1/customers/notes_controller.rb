module Api
  module V1
    module Customers
      class NotesController < ActionController::API
        def index
          render json: { action: 'index', controller: 'customers/notes', customer_id: params[:customer_id] }
        end

        def create
          render json: { action: 'create', controller: 'customers/notes', customer_id: params[:customer_id] }
        end

        def show
          render json: { action: 'show', controller: 'customers/notes', customer_id: params[:customer_id],
                         id: params[:id] }
        end

        def update
          render json: { action: 'update', controller: 'customers/notes', customer_id: params[:customer_id],
                         id: params[:id] }
        end

        def destroy
          render json: { action: 'destroy', controller: 'customers/notes', customer_id: params[:customer_id],
                         id: params[:id] }
        end
      end
    end
  end
end
