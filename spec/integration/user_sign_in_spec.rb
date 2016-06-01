require "./spec/spec_helper"

describe "user sign in flow", :ch4 => true do
  fixtures :users

  it "has a sign in form" do
    visit "/sign_in"

    page.should have_selector("form")
    page.should have_selector("form input#email")
    page.should have_selector("form input#password")
    page.should have_selector("form input[type='submit']")
  end

  it "allows me to sign in" do
    user = users(:bob)

    visit "/sign_in"

    within("form") do
      fill_in "email", :with => user.email
      fill_in "password", :with => "super_secret"
    end

    find("form input[type='submit']").click

    visit "/"
  end
end
