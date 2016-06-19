### Current User
Before we get started with reservations, let's take a quick detour to create a helper method we're going to use.

**app/controllers/application_controller.rb**

    class ApplicationController < ActionController::Base
      …
      
      def current_user
        User.find(session[:user_id]) if session[:user_id].present?
      end
    end

Remember how we stored the `user_id` in the `session` when the user signs in in `SessionsController`? In this helper method, we're just finding the `User` record from the id that we stored. If the user hasn't signed in, then `current_user` will just return `nil`. 

We're defining it in `ApplicationController` because that's the parent of all of the other controllers. Since the rest of the controllers we made all inherit from `ApplicationController`, this method will be available to us in all of them.
    
### The Reservation Model
we're going to use a model called `Reservation` that has a `user_id` column and `place_id` column. When a User reserves a Place, well create a Reservation record so that we can keep track of that.

First let's add a `has_many` relationship to Place. The `has_many` relationship means that one Place has many Reservations. It gives us useful Rails methods on Place so that we can do things like `place.relationships` and `place.relationships.create`. 

**app/models/place.rb**

    class Place < ActiveRecord::Base
      validates_presence_of :address_1, :city, :state, :zipcode, :name, :description, :price
      validates_numericality_of :zipcode, :price

      has_many :reservations
    end

Likewise, we'll do the same thing for User.

**app/models/place.rb**


    class User < ActiveRecord::Base
      …
      has_many :reservations
      …
    end


Now on the Reservation model, we need to add the opposite relationship. A Place `has_many` Reservations, so a Reservation `belongs_to` a Place. This also creates some useful methods for us so that we can do things like `reservation.place` and `reservation.user`.

**app/models/reservation.rb**


    class Reservation < ActiveRecord::Base
      belongs_to :user
      belongs_to :place
  
      validates_presence_of :user_id, :place_id
    end

### Reservation Form
Now let's create a form on a Place page for users to reserve a Place. We'll want to set a `@reservation` variable in the `PlacesController`. 


**app/controllers/places_controller.rb**


    def show
      @place = Place.find(params[:id])
      @reservation = @place.reservations.new
    end

Now let's use that un-saved `@reservation` variable to create a form on the Place page:


**app/views/places/show.html.haml**

    = form_for [@place, @reservation] do |form|
      = form.submit "Reserve!"

Behind the scenes, Rails is making a form that will POST to `/places/:place_id/reservations`. But we haven't defined a route to respond to that URL yet, so let's go do that now.

### Routing and the ReservationController


**config/routes.rb**

    … 
    resources :places do
      resources :reservations
    end
    … 

Now we've told our Rails app to respond to the route `/places/:place_id/reservations`, and by convention Rails will look in **app/controllers/reservations_controller.rb** for any of the routes we just created by including `resources :reservations`.


**app/controllers/reservations_controller.rb**


    class ReservationsController < ApplicationController
      def create
      	if current_user.present?
          @place = Place.find(params[:place_id])
          @reservation = @place.reservations.new(:user_id => current_user.id)

          if @reservation.save
            flash[:success] = "Reserved!"      
          else
            flash[:error] = "Sorry, we were unable to save your reservation."
          end
    
          redirect_to place_path(@place)
        else
          flash[:error] = "Please sign in to reserve a place."
          redirect_to sign_in_path
        end
      end
    end


The specific route that we care about maps to the `create` action of our controller. First, we're using the `current_user` method we created to check to see if we have a logged in user. If the logged in user is not present, we want to redirect them to the sign in page. 

Then we're finding the Place record we're going to make a reservation for, it's being passed to us as a part of the URL: `/places/:place_id/reservations` and Rails is allowing us to access it with `params[:place_id]`. 

Then, we create a new Reservation for that Place and set the `user_id` on it to the `current_user`'s id. We haven't saved the Reservation in our database yet, we've just made a Ruby variable that has all the attributes set. 

Now we call `@reservation.save` and if that returns `true` it means we've saved our record. If it's false, we're setting the `flash[:error]` to let the user know that we couldn't save their record. We don't expect to not be able to save our record, but it's good practice to cover that scenario just in case.
