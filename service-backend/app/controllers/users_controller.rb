class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

    def login # 用户登录
    user_name = params[:user_name]

    password = params[:password]

    if_remember = params[:remember].to_s.downcase == "ture"

    user = User.find_by(username: _user)
    
    unless user
      render status: 403, json: response_json(
        false,
        code:
        message: "Username or password wrong!"
      )
      return
    end

    user.save
    render status: 200, json: response_json(
      true,
      message: "Login success!"
    )
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password)
    end
end
