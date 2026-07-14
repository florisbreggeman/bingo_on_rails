class FieldsController < ApplicationController
  include Authorisation
  before_action :check_authorisation, except: %i[ get_all new ]
  after_action :update_card_time, only: %i[ new delete ]

  # This controller only does JSON!

  def get_all
    render json: Current.card.fields
  end

  def new
    Current.card.add_field(params["contents"])
  end

  def edit
    Current.field.contents = params["contents"]
    Current.field.save
  end

  def delete
    Current.field.destroy
  end

  private
    def check_authorisation
      field = Field.find(params[:field_id])
      if field&.card_id == Current.card.id
        Current.field = field
      else
        render status: 403, json: {"message": "forbidden"}
      end
    end

    def update_card_time
      Current.card.updated_at = Time.now
      Current.card.save
    end


end
