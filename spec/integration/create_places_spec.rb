require "./spec/spec_helper"

describe "the places creation process" do
  it "has a route to the new form", :ch1 => true do
    visit "/places/new"
    page.status_code.should be 200
  end

  it "has a form for a new place", :ch1 => true do 
    visit "/places/new"
    page.should have_selector("form#new_place")
  end

  it "has a form with these fields: address_1, address_2, city, state, zipcode, name, description, and price", :ch1 => true do
    visit "/places/new"  

    page.should have_selector("form#new_place input#place_address_1")
    page.should have_selector("form#new_place input#place_address_2")
    page.should have_selector("form#new_place input#place_city")
    page.should have_selector("form#new_place input#place_state")
    page.should have_selector("form#new_place input#place_zipcode")
    page.should have_selector("form#new_place input#place_name")
    page.should have_selector("form#new_place textarea#place_description")
    page.should have_selector("form#new_place input#place_price")
    page.should have_selector("form#new_place input[type='submit']")
  end

  it "allows you to create a place", :ch2 => true do
    original_count = Place.count
    visit "/places/new"
    within("form#new_place") do
      find("input#place_address_1").set("845 Webster St.")
      find("input#place_address_2").set("Apt 3")
      find("input#place_city").set("Palo Alto")
      find("input#place_state").set("Ca")
      find("input#place_zipcode").set("94301")
      find("input#place_name").set("The Heating Vent at Webster")
      find("textarea#place_description").set("Come relax at this block's finest heating element")
      find("input#place_price").set("9")
    end

    find("form#new_place input[type='submit']").click
    Place.count.should be(original_count + 1)
  end
end
