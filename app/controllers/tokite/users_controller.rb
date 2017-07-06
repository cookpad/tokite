module Tokite
  class UsersController < ApplicationController
    def index
      @users = User.all.order(:id)
    end
  
    def create
      @user = User.create_group_user!("group name")
      flash[:info] = "User created."
      redirect_to edit_user_path(@user)
    end
  
    def edit
      @user = User.find(params[:id])
    end
  
    def update
      @user = User.find(params[:id])
      @user.update!(user_params)
      flash[:info] = "User updated."
      redirect_to edit_user_path(@user)
    end
  
    def destroy
      @user = User.find(params[:id])
      if @user.group_user?
        @user.destroy!
        flash[:info] = "User deleted."
        redirect_to users_path
      else
        head 400
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name)
    end
  end
end
