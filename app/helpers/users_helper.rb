module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def current_user?(user)
   user == current_user
  end

  def current_user
    if (user_id = session[:user_id])
     @current_user ||= User.find_by(id: user_id)
   elsif (user_id = cookies.signed[:user_id])
     user = User.find_by(id: user_id)
     if user && user.authenticated?(cookies[:remember_token])
       log_in user
       @current_user = user
     end
   end
 end


end
