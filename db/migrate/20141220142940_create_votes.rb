class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :poll, index: true
      t.integer :candidate_id
      t.string  :nickname

      t.timestamps null: false
    end
  end
end
