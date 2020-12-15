module Api
  module V1
    class ApiController < ::ApplicationController
      acts_as_token_authentication_handler_for User
      before_action :authenticate_user!

      rescue_from ActiveRecord::RecordNotFound, :with => :handle_record_not_found

      private

      def authenticate_user!
        if !user_signed_in?
          return render json: {error: "Unauthenticated request!"}, status: :unauthorized
        end
      end

      def handle_record_not_found
        render json: {error: "Record not found!"}, status: :not_found
      end
    end
  end
end
