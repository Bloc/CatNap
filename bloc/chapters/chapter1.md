**Fact:** Cats like to nap. 

**Fact:** There are trillions of cats in the world.

**Fact:** There is no existing solution for cats to easily find places to nap when they're on the go. 

**The solution:** We're going to build the next AirBnB, but for cats. Let's get started.

## Tasks to Pass:  

* It has a route to the new place page
* It has a form tag on the page
* It has a form with the following fields: address_1, address_2, city, state, zipcode, name, description, and price

The first thing we need to do is be able to create places for these cats to nap in. Let's start by creating a route:

**config/routes.rb**:

    CatNap::Application.routes.draw do
      resources :places # this creates all the routes we need for Places
      
      match "/", :to => "landing#index"
      root :to => "landing#index"
     end

Rails will route all URLs like "/places" and "/places/new" to `PlacesController` now, but we have to tell `PlacesController` what to do when someone visits those URLs, let's start by letting users create a new place. First we need to get ready to create a new `Place`:

**controllers/places_controller.rb**:

	class PlacesController < ApplicationController
      def new
        @place = Place.new
      end
    end
    
Another convention that Rails uses is to look in `app/views/places/new.html.haml` for the markup to render with this route, so let's add a form to that view for users to fill out and submit a new `Place`:

**views/places/new.html.haml**:

    = form_for @place do |form|
      = form.label :address_1
      = form.text_field :address_1
      = form.label :address_2
      = form.text_field :address_2
      = form.label :city
      = form.text_field :city
      = form.label :state
      = form.text_field :state
      = form.label :zipcode
      = form.text_field :zipcode
      = form.label :name
      = form.text_field :name
      = form.label :description
      = form.text_area :description
      = form.label :price
      = form.text_field :price
      = form.submit
      
We're using a tool called Haml to create the markup. Everything in *views/places/new.html.haml* will get converted into HTML. The `=` you see on the left side of every row is telling Haml: "everything on the right side is Ruby code that you should evaluate and print in the markup". 

The identation in Haml is important, that's how Haml knows what markup is inside other markup. Make sure you use the same indentation you see here.
