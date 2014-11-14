require 'httparty'
require 'sinatra'
require 'json'
require 'securerandom'


get '/redirect_auth_url' do
  client_id = ENV['CLIENT_ID_KEY']
  redirect "https://accounts.google.com/o/oauth2/auth?" +
  "scope=email%20profile" +
  "&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome" +
  "&redirect_uri=http://localhost:9393/oauth2callback" +
  "&response_type=code" +
  "&client_id=#{client_id}" +
  "&approval_prompt=force"
end

get '/oauth2callback' do

  token_response = HTTParty.post("https://accounts.google.com/o/oauth2/token",
    body: {
      code: params[:code],
      client_id: ENV['CLIENT_ID_KEY'],
      redirect_uri: "http://localhost:9393/oauth2callback",
      client_secret: ENV['CLIENT_SECRET_KEY'],
      grant_type: "authorization_code"
      })

  people_response = HTTParty.get("https://www.googleapis.com/plus/v1/people/me?access_token=#{token_response['access_token']}")

  email_response = people_response["emails"][0]["value"]
  username_response = people_response["displayName"]

  #sign in with google
  sign_in_user = User.where(:email => email_response).first
  if sign_in_user != nil
    session[:user_id] = User.where(:email => email_response).first.id
    redirect '/'
  #else sign up with google
  else
    user = User.create(:username => username_response, :email => email_response, :password => SecureRandom.hex)
    if user != nil
    session[:user_id] = user.id
    redirect '/'
  else
    redirect '/test'
  end
end

end