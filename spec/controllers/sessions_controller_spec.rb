require "./spec/spec_helper"

describe SessionsController, :ch4 => true do
  describe "#create" do
    fixtures :users

    it "sets the user id in the session" do
      user = users(:bob)

      post :create, :email => user.email, :password => "super_secret"
      puts session.inspect
      session[:user_id].should == user.id
    end
  end
end
