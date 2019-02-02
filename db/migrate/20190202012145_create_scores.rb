class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|

      t.belongs_to :player, index: true
      t.date :date
      t.timestamps
    end
  end
end
