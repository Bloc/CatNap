require "./spec/spec_helper"

describe Reservation, :ch5 => true do
  it "validates the presence of the user_id" do
    reservation = Reservation.new(:place_id => 1)
    reservation.should_not be_valid
  end

  it "validates the presence of the place_id" do
    reservation = Reservation.new(:user_id => 1)
    reservation.should_not be_valid
  end
end
