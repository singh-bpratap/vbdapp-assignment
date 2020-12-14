module Api
  module V1
    class EventsController < ApiController
      before_action :set_user
      before_action :set_event, only: [:show, :update, :destroy]

      # GET /events
      def index
        @events = @user.events.all

        render json: @events
      end

      # GET /events/1
      def show
        render json: @event
      end

      # POST /events
      def create
        @event = @user.events.new(event_params)

        if @event.save
          render json: @event, status: :created
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /events/1
      def update
        if @event.update(event_params)
          render json: @event
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end

      # DELETE /events/1
      def destroy
        if @event.destroy
          render json: {message: "Event deleted successfully."}, status: 200
        else
          render json: {error: "Event could not be deleted due to some error."}, status: :unprocessable_entity
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_event
        @event = @user.events.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def event_params
        params.require(:event).permit(:start_date, :end_date, :duration, :name, :description, :location, :status)
      end

      def set_user
        @user = User.find(params[:user_id])
      end
    end
  end
end