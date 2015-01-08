class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.string :url , index: true
      t.timestamps
    end
  end
end
