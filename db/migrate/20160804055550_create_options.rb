class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :name
      t.decimal :stock_price
      t.decimal :strike_price
      t.decimal :years_to_maturity
      t.decimal :risk_free_interest_rate
      t.decimal :volatality
      t.boolean :call_flag, default: true
      t.decimal :range_array, array: true
      t.decimal :black_scholes_values, scale: 4, precision: 10, array: true
      t.string :range_attribute
      t.decimal :range_to
      t.references :guest
      t.decimal :interval, scale: 4, precision: 10

      t.timestamps null: false
    end
  end
end
