class FieldsController < ApplicationController
  include Authorisation

  def get_all
    render json: @card.fields
  end

  def new
    @card.add_field(params["contents"])
  end

end
