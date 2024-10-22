class GameAccountsController < ApplicationController
  include GameAccountsHelper

  def add_page
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой странице, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
  end

  def link_page
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой странице, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
  end

  def sell_page
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой странице, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
  end

  def sell_publish
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой функции, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
    @account = GameAccount.find_by(id: params[:game_account_id])
    if @account and @account.user_id == session[:user_id]
      @selling_account = SellingAccount.new(:game_account_id=>@account.id, :seller_id=>session[:user_id],
        :price=>params[:price], :publish_datetime=>DateTime.now)
      if @selling_account.valid?
        @selling_account.save
        @account.selling = true
        @account.save
        flash[:success] = "Аккаунт #{@account.login} успешно выставлен на продажу."
        redirect_to '/game_accounts/sell_page'
      else
        flash[:warning] = @selling_account.errors.full_messages.to_sentence
        redirect_to '/game_accounts/sell_page'
      end
    else
      flash[:warning] = 'Аккаунт с указанным идентификатором не принадлежит Вам.'
      redirect_to '/game_accounts/sell_page'
    end
  end

  def cancel_sell_offer
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой функции, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
    @selling_account = SellingAccount.find(params[:id])
    @account = GameAccount.find(@selling_account.game_account_id)
    @selling_account.destroy
    @account.selling = false
    @account.save
    flash[:success] = 'Аккаунт успешно снят с продажи.'
    redirect_to home_path
  end

  def buy
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой функции, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
    @selling_account = SellingAccount.find(params[:id])
    @acc = GameAccount.find(@selling_account.game_account_id)
    if User.find(session[:user_id]).balance >= @selling_account.price
      @buyer = User.find(session[:user_id])
      @buyer.balance -= @selling_account.price
      @buyer.save
      @seller = User.find(@selling_account.seller_id)
      @seller.balance += @selling_account.price
      @seller.save
      @acc.user_id = @buyer.id
      @acc.selling = false
      @acc.save
      @selling_account.destroy
      flash[:success] = 'Аккаунт успешно куплен.'
      redirect_to home_path
    else
      flash[:warning] = 'Недостаточно бонусов на балансе.'
      redirect_to home_path
    end
  end

  def link
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой функции, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
    @account = GameAccount.find_by(login: params[:account_login])
    if @account and @account.authenticate(params[:account_password])
      @account.user_id = session[:user_id]
      @account.save
      flash[:success] = 'Аккаунт успешно привязан.'
      redirect_to '/game_accounts/link_page'
    else
      flash[:warning] = 'Неверно указан логин или пароль.'
      redirect_to '/game_accounts/link_page'
    end
  end

  def confirm_acc
    acc = GameAccount.find(params[:id])
    acc.confirmed = true
    acc.save
    flash[:success] = 'Аккаунт успешно подтвержден.'
    redirect_to show_inventory_path(acc.user_id)
  end
end
