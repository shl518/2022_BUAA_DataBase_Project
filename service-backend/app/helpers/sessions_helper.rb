module SessionsHelper
  # 用户登陆
  def log_in(user, _remember = true )
    old_values = session.to_hash
    reset_session
    session.update old_values.except('session_id')

    session[:user_id] = user.id

    remember user if _remember
  end

  def current_user

    @current_user ||= User.find_by(id: user_id)
  end

  def remember(user = current_user)
    if user
      user.remember

    end
  end
end
