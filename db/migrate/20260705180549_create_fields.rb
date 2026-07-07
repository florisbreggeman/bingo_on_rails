class CreateFields < ActiveRecord::Migration[8.1]
  def change
    create_table :fields do |t|
      t.string :contents

      t.timestamps
    end
  end
end
