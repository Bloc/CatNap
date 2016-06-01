require "./spec/spec_helper"

describe User do
  describe "validations", :ch3 => true do
    it "validates the presence of the email" do
      user = User.new(:password => "super_secret")
      user.should_not be_valid
    end

    it "validates the presence of the password" do
      user = User.new(:email => "bob@loblaw.com")
      user.should_not be_valid
    end

    it "validates the uniqueness of the email" do
      user1 = User.create(:email => "bob@loblaw.com", :password => "super_secret")
      user2 = User.create(:email => "bob@loblaw.com", :password => "other password")
      user1.should      be_valid
      user2.should_not  be_valid
    end
  end

  describe "#encrypt_password", :ch3 => true do
    it "saves the hash and salt of the password" do
      user = User.create(:email => "bob@loblaw.com", :password => "super_secret")

      user.password_hash.should be_present
      user.password_salt.should be_present

      user.password_hash.should == BCrypt::Engine.hash_secret("super_secret", user.password_salt)
    end
  end
  
  describe ".authenticate", :ch4 => true do
    fixtures :users

    it "returns the user if the email and password are correct" do
      user = users(:bob)
      User.authenticate(user.email, "super_secret").should == user
    end

    it "returns nil if the password is incorrect" do
      user = users(:bob)
      User.authenticate(user.email, "super_cereal").should be_nil
    end

    it "returns nil if the email is incorrect" do
      User.authenticate("some@email.com", "super_secret").should be_nil
    end
  end
end
