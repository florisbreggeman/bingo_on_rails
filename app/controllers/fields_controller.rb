class FieldsController < ApplicationController
  include Authorisation

  def get_all
    render json: @card.fields
  end

end
