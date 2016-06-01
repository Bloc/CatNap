require "./spec/spec_helper"

describe "viewing places" do
  fixtures :places, :users

  it "allows me to view individual places", :ch2 => true do
    place = places(:bloc_haus)
    visit place_path(place)

    attributes = place.attributes.reject {|attr| attr =~ /updated_at|created_at|user_id|id/ }
    attributes.each do |attr, value|
      page.should have_content(value)
    end
  end
  
  it "allows me to view all the places", :ch2 => true do
    place = places(:bloc_haus)
    visit places_path

    page.should have_content(place.name)
  end

  it "allows me to reserve a place", :ch5 => true do
    user = users(:bob)

    original_count = Reservation.count
    visit "/sign_in"

    within("form") do
      fill_in("email", :with => user.email)
      fill_in("password", :with => "super_secret")
    end
    find("form input[type='submit']").click

    place = places(:bloc_haus)
    visit place_path(place)
    page.should have_selector("form#new_reservation")
    find("form#new_reservation input[type='submit']").click

    Reservation.count.should be(original_count + 1)
  end
end

