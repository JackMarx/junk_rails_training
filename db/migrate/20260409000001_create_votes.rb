class CreateVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :votes do |t|
      t.references :book, null: false, foreign_key: true
      t.string :ip_address, null: false
      t.string :session_token, null: false
      t.timestamps
    end

    add_index :votes, [ :book_id, :session_token ], unique: true
    add_index :votes, :session_token
  end
end
