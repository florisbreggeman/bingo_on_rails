class CardsController < ApplicationController
  allow_unauth only: %i[ index show ]

  include Authorisation
  no_authorisation only: %i[ index show new create ]

  def index
    @cards = Card.all()
  end

  def show
    cookie_key = "fields_#{params[:id]}"
    store = cookies[cookie_key]
    @card = Card.find(params[:id])
    @complete = @card.size >= 24
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
    @card.name = params[:name]
    @card.free_space = params[:free_space]
    @card.save
    redirect_to "/card/#{@card.id}"
  end

  private
    def show_field(field)
      return "<td class='field' id='field-#{field.id}'>#{field.contents}</td>"
    end
end
