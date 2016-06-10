class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.string :url , index: true, unique: true
      t.timestamps null: false
    end
  end
end
