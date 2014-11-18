require 'faker'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ home page and about ~~~~~~~~~~~~~~~~~~~~~~~~~~

get '/' do
  @items = Item.all
  erb :all_dishes
end

post '/' do
  loc = Geokit::Geocoders::GoogleGeocoder.geocode(params[:search_address])
  distances = []
  # Location.all.order(loc.distance_to(Geokit::Geocoders::GoogleGeocoder.geocode(Res))
  closest_distance = loc.distance_to(Geokit::Geocoders::GoogleGeocoder.geocode(Location.all.first.address))
  closest_restaurant = Location.all.first.restaurant

  Location.all.each do |location|
    temp_distance = loc.distance_to(Geokit::Geocoders::GoogleGeocoder.geocode(location.address))
    if temp_distance < closest_distance
      closest_distance = temp_distance
      closest_restaurant = location.restaurant
    end
  end

    @items = closest_restaurant.items
    erb :all_dishes

  end


get '/about' do
  erb :about
end

get '/restaurants' do
  @restaurants = Restaurant.all
  erb :list_of_restaurants
end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Restaurant sign up ~~~~~~~~~~~~~~~~~~~~~~~~~~
get '/restaurants/new' do
  erb :restaurant_signup
end

#BUBGUG - not redirecting when restaurant signs in - may be problem in layout - or not creating
post '/restaurants' do
  if Restaurant.exists?(:email => params[:email])
    @error = "That email is already registered"
    erb :restaurant_signup
  else
    restaurant = Restaurant.create(:email => params[:email], :name => params[:name], :password => params[:password])
    if restaurant.nil?
      @error = "Invalid credentials" #fallback unknown error message
      erb :restaurant_signup
    else
      session[:user_id] = nil
      session[:restaurant_id] = restaurant.id
      redirect '/'
    end
  end

end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ User sign up ~~~~~~~~~~~~~~~~~~~~~~~~~~

get '/users/new' do
  erb :user_signup
end

post '/users' do
  if User.exists?(:username => params[:username])
    @error = "That username is already registered"
    erb :user_signup
  elsif User.exists?(:email => params[:email])
    @error = "That email is already registered"
    erb :user_signup
  else
    user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
    if user.nil?
      @error = "Invalid credentials" #fallback unknown error message
      erb :user_signup
    else
      session[:restaurant_id] = nil
      session[:user_id] = user.id
      redirect '/'
    end
  end

end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ sign in ~~~~~~~~~~~~~~~~~~~~~~~~~~

post '/sessions' do

  session[:user_id] = nil
  session[:restaurant_id] = nil

  if Restaurant.exists?(:email => params[:email])
    restaurant = Restaurant.find_by(:email => params[:email])
    if restaurant != nil
      if restaurant.password == params[:password]
        session[:restaurant_id] = restaurant.id
        redirect "/restaurants/#{restaurant.id}"
      end
    end
  end

  if User.exists?(:email => params[:email])
    user = User.find_by(:email => params[:email])
    if user != nil
      if user.password == params[:password]
        session[:user_id] = user.id
        redirect '/'
      end
    end
  end
  redirect '/'
end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ log out ~~~~~~~~~~~~~~~~~~~~~~~~~~

get '/logout' do
  session[:user_id] = nil
  session[:restaurant_id] = nil
  redirect '/'
end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Restaurant management ~~~~~~~~~~~~~~~~~~~~~~~~~~


get '/restaurants/:restaurant_id' do
  if Restaurant.find(params[:restaurant_id]) != nil
    @restaurant = Restaurant.find(params[:restaurant_id])
    @items = @restaurant.items.order(:created_at => :desc)
  else
    redirect '/'
  end
  erb :restaurant
end

post '/restaurants/:restaurant_id/items' do
  item = Item.new(:title => params[:title], :price => params[:price], :description => params[:description], :picture => Faker::Avatar.image, :restaurant_id => session[:restaurant_id])
  if item != nil
    item.save
    redirect "/restaurants/#{session[:restaurant_id]}"
  else
    redirect "/restaurants/#{session[:restaurant_id]}"
  end
end


put '/restaurants/:restaurant_id/items/:item_id' do
  item = Item.find(params[:item_id])
  if item != nil
    item.title = params[:title]
    item.price = params[:price]
    item.description = params[:description]
    item.save
    redirect "/restaurants/#{session[:restaurant_id]}"
  else
    redirect "/restaurants/#{session[:restaurant_id]}"
  end
end

delete '/restaurants/:restaurant_id/items/:item_id' do
  item = Item.find(params[:item_id])
  if item != nil
    item.destroy
    redirect "/restaurants/#{session[:restaurant_id]}"
  else
    redirect "/restaurants/#{session[:restaurant_id]}"
  end
end

get '/users/:user_id/pins' do
  @pins = User.find(session[:user_id]).items
  erb :pins
end

post '/users/:user_id/pins' do

  itemid = params[:item_id_for_pin]
  userid = session[:user_id]

  pin = Pin.create(:user_id => userid, :item_id => itemid)

  content_type :json
  pin.to_json
end

delete '/users/:user_id/pins' do
  pin = Pin.where(:user_id => session[:user_id], :item_id => params[:pin_id_for_delete]).first
  pin.destroy

end

get '/users/:user_id/account' do
  @hash = Digest::MD5.hexdigest(User.find(session[:user_id]).email.downcase)
  @user = User.find(session[:user_id])
  erb :user_account
end

put '/users/:user_id/account' do

  #didnt change password for mvp
  user = User.find(session[:user_id])
  user.username = params[:username]
  user.email = params[:email]
  user.save
  redirect '/'

end