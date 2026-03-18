module Api
  module V1
    module Customers
      module Uncontacted
        class RemappedNotesController < EasyPeasyApi::ApplicationController
          def index
            set_params :customer_id
            render json: { action: 'index', controller: 'customers/uncontacted/remapped_notes',
                           customer_id: params[:customer_id] }
          end

          def create
            set_params :customer_id
            render json: { action: 'create', controller: 'customers/uncontacted/remapped_notes',
                           customer_id: params[:customer_id] }
          end

          def show
            set_params :customer_id, :id
            render json: { action: 'show', controller: 'customers/uncontacted/remapped_notes',
                           customer_id: params[:customer_id], id: params[:id] }
          end

          def update
            set_params :customer_id, :id
            render json: { action: 'update', controller: 'customers/uncontacted/remapped_notes',
                           customer_id: params[:customer_id], id: params[:id] }
          end

          def destroy
            set_params :customer_id, :id
            render json: { action: 'destroy', controller: 'customers/uncontacted/remapped_notes',
                           customer_id: params[:customer_id], id: params[:id] }
          end
        end
      end
    end
  end
end
