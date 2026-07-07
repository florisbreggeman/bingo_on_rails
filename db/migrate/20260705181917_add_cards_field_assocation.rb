class AddCardsFieldAssocation < ActiveRecord::Migration[8.1]
  def change
    add_reference :fields, :card, null: false, foreign_key: true
  end
end
