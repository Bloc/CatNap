In the last chapter, we built a sign up form to let users sign up, but we haven't done anything to let them sign in yet. Signing in is a little different because we're not creating objects that we save in the database. Instead, we're goint to let the user submit a form, confirm that their email and password are correct, and then save their `user_id` in a special browser cookie called the "session". 

We'll start the same way as before -- by creating the routes.

**config/routes.rb**

  resources :sessions
  get "sign_in", :to => "sessions#new", :as => "sign_in"

This should look familiar, except now we're going to be working in `SessionsController` instead of `UsersController`. 

**app/controllers/sessions_controller.rb**

    class SessionsController < ApplicationController
      def new
        # nothing to do here
      end
    end
    
We actually don't have to do anything in the `new` action here, and the reason is that a Session, unlike a Place or a User, is not an actual database-backed resource. In other words, we don't save sessions in the database, but we'll still call them a resource in a more abstract sense.

In the view for `SessionsController#new` we'll want to add a form to let users sign in.

**app/views/sessions/new.html.haml**

    = form_tag sessions_path do
      = label_tag :email
      = password_field_tag :email
      = label_tag :password
      = password_field_tag :password
      = submit_tag "Sign In"

That form is going to submit to the `create` action in `SessionsController`, so let's go define that next. 

**app/controllers/sessions_controller.rb**

    def create
      if user = User.authenticate(params[:email], params[:password])
        session[:user_id] = user.id
        redirect_to "/"
      else
        flash.now[:error] = "Invalid email or password"
        render :new
      end
    end


We haven't implemented `User.authenticate` yet, but basically we want to pass it an email and a password and have it return the user record if we can login that user or return `nil` if we can not. 

If we do find the user, we're going to save their `user_id` in a special cookie called the session, and then redirect them to the landing page. 

If we can not login that user we'll show an error message and send them back to the sign in page.

Let's go implement `User.authenticate` now. 

**app/models/user.rb**

    def self.authenticate(email, password)
      user = find_by_email(email)
    
      if user && BCrypt::Engine.hash_secret(password, user.password_salt) == user.password_hash
        user 
      else
        nil
      end
    end

The first thing we're doing is trying to find a user with the email passed. `find_by_email` is a method that Rails generates for you, so we'll just use that. Next we're recomputing the hash for that user based on the password that was submitted in the sign in form, and if it matches the hash that we have saved in the database for that user, that means the passwords match and we can log them in. 

Since this isn't really a cryptography and security course, we won't go into detail about how this authentication scheme works but it's a very common one. 
 
