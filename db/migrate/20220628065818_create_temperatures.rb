class CreateTemperatures < ActiveRecord::Migration[6.1]
  def change
    create_table :temperatures do |t|
      t.datetime :time, index: true
      t.float :value
      t.timestamps
    end
  end
end
