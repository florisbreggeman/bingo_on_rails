class AddFreeSpaceToCard < ActiveRecord::Migration[8.1]
  def change
    add_column :cards, :free_space, :string
  end
end
