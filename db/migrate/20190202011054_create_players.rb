class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|

      t.string :username, null: false
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
