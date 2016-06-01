require "./spec/spec_helper"

describe "user sign up flow" do
  it "has a sign up form", :ch3 => true do
    visit "/sign_up"

    page.should have_selector("form#new_user")
    page.should have_selector("form#new_user input#user_email")
    page.should have_selector("form#new_user input#user_password")
    page.should have_selector("form#new_user input#user_password_confirmation")
    page.should have_selector("form#new_user input[type='submit']")
  end

  it "allows me to sign up" do
    original_count = User.count
    visit "/sign_up"

    within("form#new_user") do
      fill_in("user_email", :with => "bob@boblawblaw.com")
      fill_in("user_password", :with => "super_secret")
      fill_in("user_password_confirmation", :with => "super_secret")
    end

    find("form#new_user input[type='submit']").click
    User.count.should be(original_count + 1)
  end

  it "requires your password confirmation to match your password" do
    original_count = User.count
    visit "/sign_up"

    within("form#new_user") do
      fill_in("#user_email", :with => "bob@boblawblaw.com")
      fill_in("#user_password", :with => "super_secret")
      fill_in("#user_password_confirmation", :with => "super_cereal")
    end

    find("form#new_user input[type='submit']").click
    User.count.should be(original_count)
  end
end
