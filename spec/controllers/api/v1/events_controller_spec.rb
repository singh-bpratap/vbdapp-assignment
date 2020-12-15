require "rails_helper"

RSpec.describe Api::V1::EventsController, type: :controller do
  before(:each) do
    @user = create(:user)
    request.headers["X-User-Email"] = @user.email
    request.headers["X-User-Token"] = @user.authentication_token
  end

  describe "GET index" do
    let!(:events) { create_list(:event, 2, user: @user) }

    it "responds with JSON" do
      get :index
      actual_data = JSON.parse(response.body)
      expect(actual_data).to match(events.as_json)
    end
  end

  describe "GET show" do
    let!(:event) { create(:event, user: @user) }

    it "responds with JSON" do
      get :show, params: {id: event.id}
      actual_data = JSON.parse(response.body)
      expect(actual_data).to match(event.as_json)
    end
  end

  describe "POST create" do
    context "with valid data" do
      let(:event_attributes) {
        build(:event)
          .attributes
          .slice("start_date", "duration", "name", "description", "location")
      }

      it "returns status created" do
        post :create, params: {event: event_attributes}
        expect(response).to have_http_status(:created)
      end

      it "create event and responds with JSON" do
        expect {
          post :create, params: {event: event_attributes}
        }.to change {Event.count}.by(1)

        actual_data = JSON.parse(response.body)
        expect(actual_data).to match(Event.last.as_json)
      end
    end

    context "with invalid data" do
      let(:event_attributes) {
        build(:event)
          .attributes
          .slice("duration", "name", "description", "location")
      }

      it "returns status unprocessable_entity" do
        post :create, params: {event: event_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with errors" do
        post :create, params: {event: event_attributes}
        expect(response.body).to eq("{\"base\":[\"At least 2 values are mandatory for start_date, end_date and duration.\"]}")
      end
    end
  end

  describe "PUT update" do
    context "with valid data" do
      let!(:event) { create(:event, user: @user) }
      let(:event_attributes) { {name: "New name"} }

      it "returns status 200" do
        put :update, params: {id: event.id, event: event_attributes}
        expect(response).to have_http_status(200)
      end

      it "update event and responds with JSON" do
        put :update, params: {id: event.id, event: event_attributes}
        actual_data = JSON.parse(response.body)
        expect(actual_data).to match(event.reload.as_json)
        expect(event.reload.name).to eq(event_attributes[:name])
      end
    end

    context "with invalid data" do
      let!(:event) { create(:event, user: @user, location: nil) }
      let(:event_attributes) { {status: "published"} }

      it "returns status unprocessable_entity" do
        put :update, params: {id: event.id, event: event_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with errors" do
        put :update, params: {id: event.id, event: event_attributes}
        expect(response.body).to eq("{\"location\":[\"can't be blank\"]}")
      end
    end
  end

  describe "DELETE destroy" do
    let!(:event) { create(:event, user: @user) }

    it "delete event and responds with success message" do
      expect {
        delete :destroy, params: {id: event.id}
      }.to change {Event.count}.by(-1)
      expect(response.body).to eq("{\"message\":\"Event deleted successfully.\"}")
    end
  end
end
