class CreateJoinTableCardField < ActiveRecord::Migration[8.1]
  def change
    create_join_table :cards, :fields do |t|
      t.index [:card_id, :field_id]
    end
  end
end
