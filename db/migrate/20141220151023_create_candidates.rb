class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.references :poll, index: true
      t.string :name

      t.timestamps
    end
  end
end
