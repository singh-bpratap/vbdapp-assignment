module Api
  module V1
    class SessionsController < Devise::SessionsController
      before_action :sign_in_params, only: :create

      # sign in
      def create
        @user = User.find_for_database_authentication(email: sign_in_params[:email])

        if @user && @user.valid_password?(sign_in_params[:password])
          sign_in "user", @user
          return render json: {
            messages: "Signed In Successfully",
            data: {user: @user}
          }, status: :ok
        else
          render json: {
            messages: "Signed In Failed - invalid email or password"
          }, status: :unauthorized
        end
      end

      private

      def sign_in_params
        params.require(:user).permit :email, :password
      end
    end
  end
end
