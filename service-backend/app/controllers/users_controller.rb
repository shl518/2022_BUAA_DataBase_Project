class UsersController < ApplicationController
  # POST /users#register
  def register
    user = User.new user_name: params[:user_name], password: params[:password]
    password_confirmation = params[:password_confirmation]

    unless user.password == password_confirmation
      render status: 412, json: response_json(
        false,
        code: UserRegisterErrorCode::INVALID_INFORMATION,
        message: "Password is not equal to password_confirmation.",
      )
    end

    if user.save
      render status: 200, json: response_json(
        true,
        message: "Register success!",
        data: {
          user_name: user[:user_name]
        }
      )
    else
      render status: 412, json: response_json(
        false,
        message: "Invalid information!"
      )
    end
  end

  # POST /user#login
  def login # 用户登录
    user_name = params[:user_name]

    password = params[:password]

    if_remember = params[:remember].to_s.downcase == "ture"

    user = User.find_by(user_name: user_name)

    unless user
      render status: 403, json: response_json(
        false,
        code: UserLoginErrorCode::USER_NOT_EXIST,
        message: "Username or password wrong!"
      )
      return
    end

    unless password != user.password
      render status: 403, json: response_json(
        false,
        code: UserLoginErrorCode::WRONG_PASSWORD_OR_USERNAME,
        message: "Username or password wrong!"
      )
      return
    end

    @user = user
    user.save
    render status: 200, json: response_json(
      true,
      message: "Login success!"
    )
  end

  # POST /user#logout
  def logout
    @user = nil
    render status: 200, json: response_json(
      true ,
      message: "Logged out!"
    )
  end

  # GET /user#
  def get_information
    render status: 200, json: response_json(
      true,
      message: "Success",
      data: {
        user_name: @user[:user_name],
        user_role: "Admin"
      }
    )
  end

end
