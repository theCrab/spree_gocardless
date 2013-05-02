class CreateSpreeGocardlessPayments < ActiveRecord::Migration
  def change
    create_table :spree_gocardless_payments do |t|
      t.string :number
      t.string :resource_id
      t.string :resource_type
      t.string :status
      t.date :paid_on

      t.timestamps
    end
  end
end
