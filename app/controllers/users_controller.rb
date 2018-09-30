class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :delete]
   before_action :correct_user,   only: [:edit, :update]
   before_action :admin_user,     only: :destroy

   def admin_user
     redirect_to(root_url) unless current_user.admin?
   end

   def index
       @users = User.paginate(page: params[:page], :per_page => 8)
   end

  def new
   @user = User.new
 end

 def admin_user
     redirect_to(root_url) unless current_user.admin?
   end

   def destroy
      User.find_by(id: params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end


    def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
   end

   # Confirms the correct user.
    def correct_user
      @user = User.find_by(id: params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

   def show
     @user = User.find_by(id: params[:id])
     @microposts = @user.microposts.paginate(page: params[:page], :per_page => 5)
     if @user.nil?
        flash[:danger] = "User dosn't exist!"
        redirect_to(root_url)
      end
    end


   def edit
     @user = User.find_by(id: params[:id])
   end

   def update
   @user = User.find_by(id: params[:id])
   if @user.update_attributes(user_params)
     flash[:success] = "Profile updated"
      redirect_to @user
   else
     render 'edit'
   end
 end

 def current_user?(user)
  user == current_user
 end


    private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
