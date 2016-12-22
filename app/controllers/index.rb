enable :sessions

get '/' do
  erb :index
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/welcome' do
  p "hola"
  erb :welcome
  # session[:user]
  # if is_not_authenticated? == false
  #   return erb :login_status
  # else
  #   @message = 'Not authenticated... no access, sorry.'
  #   return erb :login_status
  # end
end  



# Toma los datos de registro
post '/register' do
  @message = ''
  
  #Valida si el usuario no se ha registrado antes
  if does_user_exist?(params[:email]) == true
    @message = 'Username already exists'
    return erb :login_status
  end

  # Esta es otrs forma de genera password encriptados con bcrypt
  # password_salt = BCrypt::Engine.generate_salt # salt is like a KEY
  # password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  
  newbie = User.create(name: params[:user_name], email: params[:email], password:  params[:password])
  # newbie.password_hash = password_hash
  # newbie.password_salt = password_salt
  # newbie.save

  @message = 'You have sucessfully registered!'

  erb :login_status
end

# login action
post '/login' do
  puts '---------------'
  puts params
  p does_user_exist?(params[:email]) 
  puts '---------------'
  # Establece el password
  password = params[:password]
  
  @message = ''
  if does_user_exist?(params[:email]) == false
    @message = 'Sorry... but that username does not exist.'
    return erb :login_status
  else 
    # Encuentra al usuario
    user = User.find_by(email: params[:email])
    #Valida al ususario
    valid_user = User.authenticate(user.email, password)
    if valid_user
      # user.password_hash == BCrypt::Engine.hash_secret(pwd, user.password_salt)
      @message = 'You have been logged in successfully'
      #Genera la sesion del usuario
      session[:user_id] = user.id
      return erb :login_status
    else
      @message = 'Sorry but your password does not match.'
      return erb :login_status
    end
  end
end



# check and see if a user exists?
def does_user_exist?(email)
  user = User.find_by(email: email)
  if user
    return true
  else
    return false
  end
end

