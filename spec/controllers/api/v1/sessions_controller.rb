require "rails_helper"

RSpec.describe Api::V1::SessionsController, type: :controller do
  before(:each) do
    @user = create(:user)
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST create" do
    context "with valid data" do
      let(:user_attributes) {{ email: @user.email, password: "password" }}

      it "returns status 200" do
        post :create, params: {user: user_attributes}
        expect(response).to have_http_status(200)
      end

      it "generate a token and responds with JSON" do
        post :create, params: {user: user_attributes}
        json_body = JSON.parse response.body
        expect(json_body["messages"]).to eq("Signed In Successfully")
        expect(json_body["data"]["user"]).to eq(@user.as_json)
      end
    end

    context "with invalid password" do
      let(:user_attributes) {{ email: @user.email, password: "wrong-password" }}

      it "returns status unauthorized" do
        post :create, params: {user: user_attributes}
        expect(response).to have_http_status(:unauthorized)
      end

      it "responds with error message" do
        post :create, params: {user: user_attributes}
        expect(response.body).to eq("{\"messages\":\"Signed In Failed - invalid email or password\"}")
      end
    end

    context "with invalid email" do
      let(:user_attributes) {{ email: "invalid-email@mail.com", password: "password" }}

      it "returns status unauthorized" do
        post :create, params: {user: user_attributes}
        expect(response).to have_http_status(:unauthorized)
      end

      it "responds with error message" do
        post :create, params: {user: user_attributes}
        expect(response.body).to eq("{\"messages\":\"Signed In Failed - invalid email or password\"}")
      end
    end
  end
end
