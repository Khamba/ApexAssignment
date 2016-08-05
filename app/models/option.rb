# == Schema Information
#
# Table name: options
#
#  id                      :integer          not null, primary key
#  name                    :string
#  stock_price             :decimal(, )
#  strike_price            :decimal(, )
#  years_to_maturity       :decimal(, )
#  risk_free_interest_rate :decimal(, )
#  volatality              :decimal(, )
#  call_flag               :boolean          default(TRUE)
#  black_scholes_value     :decimal(, )
#  guest_id                :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Option < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { scope: :guest, message: "must not be the same as any other option that you have saved" }
  validates_numericality_of :stock_price, greater_than: 0
  validates_numericality_of :strike_price, greater_than: 0
  validates_numericality_of :years_to_maturity, greater_than: 0
  validates_numericality_of :risk_free_interest_rate, greater_than: 0, less_than: 100
  validates_numericality_of :volatality, greater_than: 0, less_than: 100

  belongs_to :guest

  before_save :calculate_black_scholes_value

  def put_flag?
    !call_flag?
  end

  private

    def cnd(x)
      a1, a2, a3, a4, a5 = 0.31938153, -0.356563782, 1.781477937, -1.821255978, 1.330274429
      l = x.abs
      k = 1.0 / (1.0 + 0.2316419 * l)
      w = 1.0 - 1.0 / Math.sqrt(2*Math::PI)*Math.exp(-l*l/2.0) * (a1*k + a2*k*k + a3*(k**3) + a4*(k**4) + a5*(k**5))
      w = 1.0 - w if x < 0
      return w
    end

    def calculate_black_scholes_value
      r = risk_free_interest_rate / 100.0
      v = volatality / 100.0
      d1 = ( Math.log(stock_price/strike_price) + ( r + v*v/2.0)*years_to_maturity)/( v*Math.sqrt(years_to_maturity) )
      d2 = d1-v*Math.sqrt(years_to_maturity)
      if call_flag?
        self.black_scholes_value = stock_price*cnd(d1)-strike_price*Math.exp(-r*years_to_maturity)*cnd(d2)
      else
        self.black_scholes_value = strike_price*Math.exp(-r*years_to_maturity)*cnd(-d2)-stock_price*cnd(-d1)
      end
    end

end
