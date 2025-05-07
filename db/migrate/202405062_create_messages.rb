class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true
      t.text :content
      t.datetime :created_at
    end
  end
end
