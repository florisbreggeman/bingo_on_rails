class FieldsController < ApplicationController
  include Authorisation

  # This controller only does JSON!

  def get_all
    render json: Current.card.fields
  end

  def new
    Current.card.add_field(params["contents"])
  end

  def edit
    field = Field.find(params[:field_id])
    field.contents = params["contents"]
    field.save
  end

  def delete
    Field.destroy(params[:field_id])
  end

end
