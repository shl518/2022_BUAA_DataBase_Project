class UserController < ApplicationController
  @@id = 50
  # POST /users#register
  def register
    user = User.new
    user[:name] = params[:user_name]
    user[:password] = params[:password]

    # unless user[:password] == password_confirmation
    #   render status: 412, json: response_json(
    #     false,
    #     code: UserRegisterErrorCode::INVALID_INFORMATION,
    #     message: "Password is not equal to password_confirmation.",
    #   )
    # end
    # if user.save
    #   render status: 200, json: response_json(
    #     true,
    #     message: "Register success!",
    #     data: {
    #       user_name: user[:name]
    #     }
    #   )
    # else
    #   puts User.errors
    #   render status: 412, json: response_json(
    #     false,
    #     message: "Invalid information!"
    #   )
    # end

    # 以下为使用sql语句进行插入操作
    begin
      execute_statement("INSERT INTO users(id, name, password, created_at, updated_at)
      VALUES (#{@@id}, '#{user[:name]}', '#{user[:password]}', '#{DateTime.parse(Time.now.to_s).strftime('%Y-%m-%d %H:%M:%S')}',
        '#{DateTime.parse(Time.now.to_s).strftime('%Y-%m-%d %H:%M:%S')}');")

      render status: 200, json: response_json(
        true,
        message: "Register success!",
        data: {
          user_name: user[:name]
        }
      )
      @@id += 1
    rescue
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

    # 以下为利用rails框架进行查询等操作

    # if_remember = params[:remember].to_s.downcase == "ture"
    #
    # user = User.find_by(name: user_name)
    #
    # unless user
    #   render status: 403, json: response_json(
    #     false,
    #     code: UserLoginErrorCode::USER_NOT_EXIST,
    #     message: "Username or password wrong!"
    #   )
    #   return
    # end
    #
    # unless password == user[:password]
    #   render status: 403, json: response_json(
    #     false,
    #     code: UserLoginErrorCode::WRONG_PASSWORD_OR_USERNAME,
    #     message: "Username or password wrong!"
    #   )
    #   return
    # end
    #
    # @user = user
    # user.save
    # render status: 200, json: response_json(
    #   true,
    #   message: "Login success!",
    #   data: {
    #     token: "admin-token"
    #   }
    # )

    # 以下为使用sql语句进行查询
    user = execute_statement("SELECT * FROM users WHERE name='#{user_name}'").as_json

    if user.empty?
      render status: 403, json: response_json(
        false,
        code: UserLoginErrorCode::USER_NOT_EXIST,
        message: "Username or password wrong!"
      )
      return
    end

    unless password == user[0][2]
      render status: 403, json: response_json(
        false,
        code: UserLoginErrorCode::WRONG_PASSWORD_OR_USERNAME,
        message: "Username or password wrong!"
      )
      return
    end

    @user = user

    render status: 200, json: response_json(
      true,
      message: "Login success!",
      data: {
        token: "admin-token"
      }
    )

  end

  # POST /user#logout
  def logout
    @user = nil
    render status: 200, json: response_json(
      true,
      message: "Logged out!"
    )
  end

  # GET /user#information
  def get_information
    render status: 200, json: response_json(
      true,
      message: "Success",
      data: {
        roles: "Admin",
        introduction: "I am a super administrator.",
        avatar: "https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif",
        name: "Super Admin"
      }
    )
  end

end
