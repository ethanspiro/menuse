require 'faker'
require 'httparty'
require 'sinatra'
require 'json'


api_url = "http://api.yummly.com/v1/api/recipes?_app_id=" + ENV['API_ID'] + "&_app_key=" + ENV['API_KEY']

  require_pictures = "&requirePictures=true"
  max_result = "&maxResult=100&start=100"
  large_images = "&images"

  p api_url = api_url + require_pictures + max_result + large_images
  @recipes = HTTParty.get(api_url)
  samples = []
  @recipes = @recipes["matches"]
  @recipes.each do |rec|
    temp = []
    temp.push(rec["recipeName"])
    temp.push(rec["ingredients"].join(", "))
    temp.push(rec['imageUrlsBySize']['90'].gsub!('s90','l360'))
    samples.push(temp)
  end


User.create(:email => "u@gmail.com", :username => "My test user", :password => "pass")

#master restaurant
Restaurant.create(:email => "r@gmail.com", :name => "My test restaurant", :password => "pass", :description => "test restaurant description")
Restaurant.create(:email => Faker::Internet.email, :name => Faker::Company.name, :password => Faker::Lorem.word, :description => Faker::Commerce.product_name)

Location.create(:address => "633 Folsom Street, San Francisco", :restaurant_id => 1)
Location.create(:address => "166 Commonwealth Ave, San Francisco", :restaurant_id => 2)

50.times do
  samp = samples.sample
  Item.create(:title => samp[0], :price => Random.rand(30)+5, :description => samp[1], :picture => samp[2], :restaurant_id => Restaurant.all.sample.id)
  samples.delete(samp)
end



