CatNap::Application.routes.draw do
  match "/", :to => "landing#index"
  root :to => "landing#index"
end
