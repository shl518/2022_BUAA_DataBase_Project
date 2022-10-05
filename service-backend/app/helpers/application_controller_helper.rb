module ApplicationControllerHelper

  include GlobalHelper

  module ErrorCodes
    include ApplicationControllerHelper::ApplicationConstants
  end

  module GlobalErrorCode
    extend ApplicationControllerHelper::ErrorCodes

    #基本异常
    SUCCESS = 0
    COMMON_ERROR = -1
    # 全局异常
    SYSTEM_ERROR = 1
  end

  def response_json(success, code: nil, message: nil, data: nil)
    success = !!success
    {
      success: success,
      code: code || (success ? GlobalErrorCode::SUCCESS : GlobalErrorCode::COMMON_ERROR),
      message: message || (success ? "Success." : "Failed."),
      data: data
    }
  end

  def execute_statement(sql)
    ActiveRecord::Base.connection.execute(sql)
  end
end