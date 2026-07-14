class CardsController < ApplicationController
  allow_unauth only: %i[ index show ]

  include Authorisation
  no_authorisation only: %i[ index my show new create ]

  def index
    @cards = Card.all().select{|card| card.complete}
    @heading = "Currently available bingo cards"
  end

  def my
    @cards = Card.all().select{|card| card.user_id == Current.user.id}
    @heading = "Your bingo cards:"
    render :index
  end

  def show
    # TODO if the card has been edited in the meantime, we should discard the cookie!
    cookie_key = "fields_#{params[:card_id]}"
    store = cookies[cookie_key]
    @card = Card.find(params[:card_id])
    if store == nil 
      ordering = @card.fields.shuffle
      cookies[cookie_key] = ordering.map { |f| f.id }.join(",")
    else
      ordering = store.split(",").map { |s| s.to_i }.map { |i| Field.find(i) }
    end
    @contents = ordering.map { |f| show_field(f) }
  end

  def new
  end

  def edit
    @card = Current.card
  end

  def create
    card = Card.new
    card.user_id = Current.user.id
    card.name = params[:name]
    card.free_space = params[:free_space]
    card.save

    redirect_to "/card/#{card.id}"
  end

  def change
    Current.card.name = params[:name]
    Current.card.free_space = params[:free_space]
    Current.card.save
    redirect_to "/card/#{Current.card.id}"
  end

  private
    def show_field(field)
      return "<td class='field' id='field-#{field.id}'>#{field.contents}</td>"
    end
end
