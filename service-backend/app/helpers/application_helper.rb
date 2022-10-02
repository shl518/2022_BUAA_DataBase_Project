module ApplicationHelper
  module UserLoginErrorCode
    extend ::ApplicationControllerHelper::ErrorCodes

    ACCESS_DENIED = 100
    USER_NOT_EXIST = 101
    WRONG_PASSWORD_OR_USERNAME = 102
    LOGIN_FAILED = 103
  end

  module UserRegisterErrorCode
    extend ::ApplicationControllerHelper::ErrorCodes

    INVALID_INFORMATION = 300
  end
end
