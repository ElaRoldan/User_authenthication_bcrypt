class User < ActiveRecord::Base
  include BCrypt
  # Validaciones para el usuario
  validates :email, uniqueness: true,  presence: true
  validates :password, :name, presence: true


 #El método Password es una clase de BCrypt la cual genera el hash.
 def password
    @password ||= Password.new(password_digest)
  end

 def password=(user_password)
   @password = Password.create(user_password)
   self.password_digest = @password
 end

  #método de autenticación
  def self.authenticate(email, user_password)
    user = User.find_by(email: email)
    if user && (user.password == user_password)
      return user
    else
      nil
    end
  end



end
