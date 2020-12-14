class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :duration
      t.string :name
      t.text :description
      t.text :location
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
