class CardsController < ApplicationController
  allow_unauth only: %i[ index show ]

  def index
    @cards = Card.all()
  end

  def show
    cookie_key = "fields_#{params[:id]}"
    store = cookies[cookie_key]
    @card = Card.find(params[:id])
    if store == nil 
      @complete = @card.size >= 24
      ordering = @card.fields.shuffle
      cookies[cookie_key] = ordering.map { |f| f.id }.join(",")
    else
      ordering = store.split(",").map { |s| s.to_i }.map { |i| Field.find(i) }
      @complete = true
    end
    @contents = ordering.map { |f| show_field(f) }
  end

  private
    def show_field(field)
      return "<td class='field' id='field-#{field.id}'>#{field.contents}</td>"
    end
end
