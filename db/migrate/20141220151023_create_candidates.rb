class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.references :poll, index: true
      t.string :name
      t.string :created_by # to remove candidates if they have no vote

      t.timestamps null: false
    end
  end
end
