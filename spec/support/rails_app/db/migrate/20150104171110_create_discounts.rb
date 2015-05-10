class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|

      t.string :name
      t.integer :amount
      t.references :event

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
