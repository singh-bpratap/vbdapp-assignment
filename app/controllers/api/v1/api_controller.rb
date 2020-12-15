module Api
  module V1
    class ApiController < ::ApplicationController
      acts_as_token_authentication_handler_for User
      before_action :authenticate_user!

      private

      def authenticate_user!
        if !user_signed_in?
          return render json: {error: "Unauthenticated request!"}, status: :unauthorized
        end
      end
    end
  end
end
