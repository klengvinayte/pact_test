class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, default: '', null: false
      t.string :surname, default: '', null: false
      t.string :patronymic, default: ''
      t.string :fullname, default: ''
      t.string :email, default: '', null: false
      t.integer :age, null: false
      t.string :nationality, default: ''
      t.string :country, default: '', null: false
      t.string :gender, default: '', null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
