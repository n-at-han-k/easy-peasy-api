module Api
  module V1
    module Customers
      module Uncontacted
        class NotesController < ActionController::API
          def index
            render json: { action: 'index', controller: 'customers/uncontacted/notes',
                           uncontacted_id: params[:uncontacted_id] }
          end

          def create
            render json: { action: 'create', controller: 'customers/uncontacted/notes',
                           uncontacted_id: params[:uncontacted_id] }
          end

          def show
            render json: { action: 'show', controller: 'customers/uncontacted/notes',
                           uncontacted_id: params[:uncontacted_id], id: params[:id] }
          end

          def update
            render json: { action: 'update', controller: 'customers/uncontacted/notes',
                           uncontacted_id: params[:uncontacted_id], id: params[:id] }
          end

          def destroy
            render json: { action: 'destroy', controller: 'customers/uncontacted/notes',
                           uncontacted_id: params[:uncontacted_id], id: params[:id] }
          end
        end
      end
    end
  end
end
