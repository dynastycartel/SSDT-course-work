class ItemsController < ApplicationController
  include ItemsHelper
  
  def index
  end

  def add_page
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой странице, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end   
  end

  def trade_page
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

  def trade_item_page
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой странице, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end   
  end

  def trade_account_page
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
    @item = Item.find_by(id: params[:item_id])
    @acc_ids_arr = []
    GameAccount.where(user_id: session[:user_id]).each do |acc|
      @acc_ids_arr.append(acc.id)
    end
    if @item and @acc_ids_arr.include? @item.game_account_id
      unless @item.selling
        @selling_item = SellingItem.new(:item_id=>params[:item_id], :seller_account_id=>@item.game_account_id,
         :price=>params[:price], :publish_datetime=>DateTime.now)
        if @selling_item.valid?
          @selling_item.save
          @host_acc = GameAccount.find(@item.game_account_id)
          @item.selling = true
          @item.save
          @host_acc.recommended_price -= @item.recommended_price
          @host_acc.save
          flash[:success] = "Предмет \"#{@item.name}\" успешно выставлен на продажу."
          redirect_to '/items/sell_page'
        else
          flash[:warning] = @selling_item.errors.full_messages.to_sentence
          redirect_to '/items/sell_page'
        end
      else
        flash[:warning] = 'Предмет уже выставлен на продажу.'
        redirect_to '/items/sell_page'
      end
    else
      flash[:warning] = 'Вы не владеете предметом с указанным идентификатором.'
      redirect_to '/items/sell_page'
    end
  end

  def trade_publish
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой функции, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
    @item_to_offer = Item.find_by(id: params[:offered_item_id])
    @acc_ids_arr = []
    GameAccount.where(user_id: session[:user_id]).each do |acc|
      @acc_ids_arr.append(acc.id)
    end
    if @item_to_offer and @acc_ids_arr.include? @item_to_offer.game_account_id
      unless @item_to_offer.selling
        @exchange_offer = ExchangeItem.new(:posted_item_id=>@item_to_offer.id,
          :desired_item_name=>params[:desired_item_name], :publish_datetime=>DateTime.now)
        if @exchange_offer.valid?
          @exchange_offer.save
          @item_to_offer.selling = true
          @item_to_offer.save
          flash[:success] = 'Предмет успешно выставлен на обмен.'
          redirect_to '/items/trade_page'
        else
          flash[:warning] = @exchange_offer.errors.full_messages.to_sentence
          redirect_to '/items/trade_page'
        end
      else
        flash[:warning] = 'Ваш предмет уже находится на продаже или обмене.'
        redirect_to '/items/trade_page'
      end
    else
      flash[:warning] = 'Вы не владеете предметом с указанным в первом поле идентификатором.'
      redirect_to '/items/trade_page'
    end 
  end

  def cancel_trade_offer
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой функции, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
    @trading_offer = ExchangeItem.find(params[:id])
    @item = Item.find(@trading_offer.posted_item_id)
    @trading_offer.destroy
    @item.selling = false
    @item.save
    flash[:success] = 'Предмет успешно снят с обмена.'
    redirect_to home_path  
  end

  def trade_confirm
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой функции, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
    @trading_offer = ExchangeItem.find(params[:id])
    @all_items = []
    for acc in GameAccount.where(user_id: session[:user_id])
      @all_items.append(*Item.where(game_account_id: acc.id))
    end
    for item in @all_items
      if item.name == @trading_offer.desired_item_name
        @item_to_give = item
        found = true
        break
      end
    end
    if found
      @my_new_item = Item.find(@trading_offer.posted_item_id)
      @item_to_give.game_account_id, @my_new_item.game_account_id = @my_new_item.game_account_id, @item_to_give.game_account_id
      @my_new_item.save
      @item_to_give.save
      @trading_offer.destroy
      flash[:success] = 'Обмен успешно осуществлен.'
      redirect_to home_path
    else
      flash[:warning] = 'Вы не владеете запрашиваемым предметом.'
      redirect_to home_path
    end
  end

  def add
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой функции, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
  end

  def cancel_sell_offer
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой функции, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
    @selling_item = SellingItem.find(params[:id])
    @item = Item.find(@selling_item.item_id)
    @host_acc = GameAccount.find(@item.game_account_id)
    @selling_item.destroy
    @item.selling = false;
    @item.save
    @host_acc.recommended_price += @item.recommended_price
    @host_acc.save
    flash[:success] = 'Предмет успешно снят с продажи.'
    redirect_to home_path
  end

  def buy_item
    unless session[:user_id]
      flash[:warning] = 'Чтобы получить доступ к этой функции, необходимо авторизоваться на сайте.'
      redirect_to home_path
      return false
    end
    @acc = GameAccount.find_by(id: params[:account_id])
    if @acc and @acc.user_id == session[:user_id]
      @selling_item = SellingItem.find(params[:offer_id])
      @item = Item.find(@selling_item.item_id)
      @item.game_account_id = @acc.id
      @item.selling = false
      @acc.recommended_price += @item.recommended_price
      @buyer = User.find(session[:user_id])
      @seller = User.find(GameAccount.find(@selling_item.seller_account_id).user_id)
      if @buyer.balance >= @selling_item.price
        @buyer.balance -= @selling_item.price
        @seller.balance += @selling_item.price
        @selling_item.destroy
        @acc.save
        @item.save
        @buyer.save
        @seller.save
        flash[:success] = 'Покупка осуществлена успешно.'
      else
        flash[:warning] = 'Недостаточно бонусов на балансе.'
      end
    else
      flash[:warning] = 'Аккаунт с указанным идентификатором не принадлежит Вам.'
    end
  end
end
