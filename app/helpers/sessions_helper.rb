module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end 
  
  def forget(user)
    user.forget #Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  #セッションと@current_userを破棄します
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  #一時的セッションにいるユーザーを返します。
  #それ以外の場合はcookiesに対応するユーザーを返します。
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  def current_user?(user)
    user == current_user
  end
  
  #現在ログイン中のユーザーがいればtrue,そうでなければfalseを返します
  def logged_in?
    !current_user.nil?
  end
  
  def redirect_back_or(default_url)
    redirect_to(session[:forwading_url] || default_url)
    session.delete(:forwarding_url)
  end
  
  #アクセスしようとしたURLを記憶
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
