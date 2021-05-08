# VERB        # PATH              # CONTROLLER ACTION
# GET	        /photos	            index
# GET	        /photos/new	        new
# POST	      /photos	            create
# GET	        /photos/:id	        show
# GET	        /photos/:id/edit	  edit
# PATCH/PUT	  /photos/:id	        update
# DELETE	    /photos/:id     	  destroy

# namespaces (such as admin) to move resources under a path - Requires the resource is under the admin directory
# scope module 'admin' to achieve same result ^ but leave the resource controller under controllers

# nesting (limit to 1) creates: /resourceA/1/resourceB/2/resourceC/3
# use: shallow or shallow_path, allows us to skip an id on resourceA, and just do resourceA/resourceB/:id

# REST
# member keyword to map to custom functions

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resource :hello_world do
    # Equivalent to
    # get 'hello', on: :collection
    collection do # does not require id
      get 'hello' # hello_world/hello
    end

    # get 'hello', on: :member would be params[:hello_id]
    member do # use this to require an id
      get 'hello_id' # hello_word/:id/hello
    end
  end

  resource :reservation do
    collection do # does not require id
      post "hopr", to: "reservations#find_hopr_reservations"
    end
  end
end
