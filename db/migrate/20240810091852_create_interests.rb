class CreateInterests < ActiveRecord::Migration[7.1]
  def change
    create_table :interests do |t|
      t.string :name, default: ''

      t.timestamps
    end
  end
end
