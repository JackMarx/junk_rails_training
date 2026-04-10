class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.date :published_on
      t.decimal :cost, precision: 9, scale: 2

      t.timestamps
    end
  end
end
