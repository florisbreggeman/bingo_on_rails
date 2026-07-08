class AddUserCardAssociation < ActiveRecord::Migration[8.1]
  def change
    User.create! id: 1, username: "admin", name: "Default Administrator", password: "Welcome123!"

    add_reference :cards, :user, null: false, foreign_key: true, default: 1
  end
end
