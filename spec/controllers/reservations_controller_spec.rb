require "./spec/spec_helper"

describe ReservationsController do
  describe "#create", :ch5 => true do
    fixtures(:places)

    before do
      @place = places(:bloc_haus)
    end

    it "requires that the user is signed in" do
      post :create, :place_id => @place.id
      response.should redirect_to("/sign_in")
    end

    context "as a signed in user" do
      fixtures :users

      before do
        @user = users(:bob)
        session[:user_id] = @user.id
      end

      it "creates a reservation" do
        post :create, :place_id => @place.id
        reservation = Reservation.last
        reservation.user_id.should be(@user.id)
        reservation.place_id.should be(@place.id)
      end
    end
  end
end
