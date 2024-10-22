class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    unless user
      flash[:warning] = 'Неверный адрес эл. почты или пароль.'
      redirect_to '/sessions/new'
      return
    end
    if user.authenticate(params[:password])
      unless user.banned
        session[:user_id] = user.id
        flash[:success] = "Добро пожаловать, #{user.username}!"
        redirect_to home_path
      else
        reset_session
        flash[:warning] = 'Этот аккаунт заблокирован на торговой площадке.'
        redirect_to '/sessions/new'
      end
    else
      flash[:warning] = 'Неверный адрес эл. почты или пароль.'
      redirect_to '/sessions/new'
    end
  end

  def destroy
    reset_session
    flash[:success] = "Выход успешно завершен."
    redirect_to home_path
  end

  def new
  end
end
