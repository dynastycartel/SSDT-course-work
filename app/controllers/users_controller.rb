class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      flash[:success] = "Добро пожаловать, #{@user.username}!"
      redirect_to home_path
    else
      flash[:warning] = @user.errors.full_messages.to_sentence
      redirect_to '/users/new'
    end
  end

  def new
  end

  def profile_page
    @user = User.find(params[:id])
  end

  def inventory
    @user = User.find(params[:id])
  end

  def comments
    @user = User.find(params[:id])
  end

  def write_comment_page
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой странице, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return
    end
    @user = User.find(params[:id])
  end

  def comment_publish
    @comment = Comment.new(comment_params)
    if @comment.valid?
      @comment.save
      flash[:success] = 'Комментарий успешно оставлен'
      redirect_to show_comments_path(@comment.commented_user_id)
    else
      flash[:warning] = @comment.errors.full_messages.to_sentence
      redirect_to '/users/write_comment_page'
    end
  end

  def profile_update
    user = User.find(session[:user_id])
    user.username = params[:new_username]
    user.bio = params[:new_bio]
    unless params[:new_profile_pic].nil?
      user.profile_pic = params[:new_profile_pic]
    end
    user.save
    flash[:success] = 'Изменения успешно сохранены.'
    redirect_to "/users/#{session[:user_id]}"
  end

  def restore_password_page
  end

  def restore_password
    @user = User.find_by(email: params[:email])
    if @user.nil? 
      flash[:warning] = 'Пользователя с указанным адресом эл. почты не существует.'
      redirect_to '/users/restore_password_page'
    else
      if params[:secret_word] == @user.secret_word
        if params[:password] == params[:password_confirmation]
          @user.password = params[:password]
          @user.password_confirmation = params[:password]
          @user.save
          flash[:success] = 'Пароль успешно изменен.'
          redirect_to '/sessions/new'
        else
          flash[:warning] = 'Пароли не совпадают.'
          redirect_to '/users/restore_password_page'
        end
      else
        flash[:warning] = 'Неверное секретное слово.'
        redirect_to '/users/restore_password_page'
      end
    end
  end

  def profile_settings
  end

  def users_stats
    unless session[:user_id] and User.find(session[:user_id]).superuser
      flash[:warning] = 'Чтобы получить доступ к этой странице, необходимо авторизоваться на сайте в роли администратора.'
      redirect_to home_path
    end
  end

  def lots_stats
    unless session[:user_id] and User.find(session[:user_id]).superuser
      flash[:warning] = 'Чтобы получить доступ к этой странице, необходимо авторизоваться на сайте в роли администратора.'
      redirect_to home_path      
    end
  end

  def support
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой странице, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return
    end
  end

  def write_request_page
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой странице, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return
    end
  end

  def request_publish
    @request = Comment.new(commenting_user_id: params[:commenting_user_id], body: params[:body],
      publish_datetime: DateTime.now, support: true, score: 5)
    if @request.valid?
      @request.save
      flash[:success] = 'Заявка успешно оставлена. Ответ появистя на этой же странице.'
      redirect_to '/users/support'
    else
      flash[:warning] = 'Текст заявки не может быть пустым.'
      redirect_to '/users/write_request_page'
    end
  end

  def reply_publish
    @reply = Comment.new(commenting_user_id: session[:user_id], commented_user_id: params[:commented_user_id],
      support: true, score: 5, publish_datetime: DateTime.now, body: params[:body])
    if @reply.valid?
      @reply.save
      flash[:success] = 'Ответ успешно опубликован.'
      redirect_to '/users/support'
    else
      flash[:warning] = 'Текст ответа не может быть пустым.'
      redirect_to '/users/reply_request_page'
    end
  end

  def block
    user = User.find(params[:id])
    user.banned = true
    user.save
    flash[:success] = 'Пользователь успешно заблокирован.'
    redirect_to '/users/users_stats'
  end

  def unblock
    user = User.find(params[:id])
    user.banned = false
    user.save
    flash[:success] = 'Пользователь успешно разблокирован.'
    redirect_to '/users/users_stats'
  end

  def user_params
    params.permit(:email, :username, :password, :password_confirmation, :secret_word)
  end

  def comment_params
    params.permit(:commenting_user_id, :commented_user_id, :score, :body, :publish_datetime)
  end


end
