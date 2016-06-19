Now that we can create and view places, we want to let our cats register and sign up. You can think of the last chapters as us creating the Place resource, and now we're going to work on the User resource. First let's add some routes for our new resource:

**config/routes.rb**

    …
    resources :users
    get "/sign_up" => "users#new", :as => :sign_up
    …
    
Like with Places, the first line gives us routes for "/users", "/users/new", etc. The second line tells Rails to route the URL "/sign_up" to the action `new` in `UsersController`. This is mostly for convenience, the URL "/users/new" will go to the same place but we'd like to have a nicer looking URL. 

The `:as => :sign_up` part just creates the helper method `sign_up_path` for us to use in our views and controllers.

Now we'll tell `UsersController` how to respond in the `new` action:


**app/controllers/users_controller.rb** 

    def new
      @user = User.new
    end

Same thing as before, we create a new `User` that's not saved to the database so that we can use it in our form:

**app/views/users/new.html.haml**

    = form_for @user do |form|
      = form.label :email
      = form.text_field :email
      = form.label :password 
      = form.password_field :password
      = form.label :password_confirmation
      = form.password_field :password_confirmation
      = form.submit 

And this form will submit to the `create` action in `UsersController`, just like how it did with Places.

**app/controllers/users_controller.rb**

  	def create
  	  @user = User.new(params[:user])
      
      if @user.save
        redirect_to '/'
      else
    	render :new
       end
  	end

### Storing Passwords Securely

One last thing we need to do is store our passwords safely. The best practice is to not save the actual password, but save a cryptographic hash of it instead. In our database, we won't actually have a `password` column, but `password_hash` and `password_salt` columns instead. 


**app/models/user.rb**

    require "bcrypt"

    class User < ActiveRecord::Base
      attr_accessor :password
      before_create :encrypt_password
      
      def encrypt_password
        self.password_salt = BCrypt::Engine.generate_salt     
        self.password_hash = BCrypt::Engine.hash_secret(self.password, self.password_salt)
      end
    end

First we're adding the `BCrypt` library which we'll use for some crypto-security magic. `password` isn't a database column, but in order for our user form to work correctly it still needs to be an attribute on our `@user` instance so we add `attr_accessor :password` to the user model.

Next we're telling Rails that before we create a user record, we want to generate the `password_hash` and `password_salt` attributes.

Now we want to add a few validations for the password and email:
    
    validates_confirmation_of :password
    validates_presence_of :email, :password
    validates_uniqueness_of :email

The first line is a helper that tells Rails to validate that `password` is the same as `password_confirmation`. The second line is ensuring that the user doesn't leave the `email` or `password` blank.

The last one is to make sure that you can't sign up with an email that is already being used. 

