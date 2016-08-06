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
#  range_array             :decimal(, )      is an Array
#  black_scholes_values    :decimal(, )      is an Array
#  range_attribute         :string
#  range_to                :decimal(, )
#  guest_id                :integer
#  interval                :decimal(10, 4)
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
  validates :range_attribute, inclusion: { in: [ 'stock_price', 'years_to_maturity', 'risk_free_interest_rate', 'volatality' ] }, allow_blank: true
  validate :range_to_greater_than_range_from
  validates_numericality_of :interval, unless: 'range_attribute.blank?'
  validate :interval_is_less_than_range_difference, unless: 'range_attribute.blank?'

  belongs_to :guest

  before_save :calculate_values

  def put_flag?
    !call_flag?
  end

  def range_from
    self.send(range_attribute)
  end

  private

    def calculate_values
      default_values = {
        'stock_price' => stock_price,
        'strike_price' => strike_price,
        'years_to_maturity' => years_to_maturity,
        'risk_free_interest_rate' => risk_free_interest_rate,
        'volatality' => volatality
      }
      self.range_array = []
      self.black_scholes_values = []
      unless range_attribute.blank?
        i = range_from
        while i <= range_to
          self.range_array << i
          default_values[range_attribute] = i
          self.black_scholes_values << calculate_black_scholes_value(default_values)
          i += interval
        end
      else
        self.black_scholes_values << calculate_black_scholes_value(default_values)
      end
    end

    def interval_is_less_than_range_difference
      if range_to and range_from and !interval.blank?
        difference = range_to - range_from
        if interval > difference
          errors.add(:interval, "must be less than #{difference}")
        end
      end
    end

    def range_to_greater_than_range_from
      if !range_attribute.blank? and !range_from.blank?
        unless range_to.is_a?(Numeric)
          errors.add(range_attribute, 'To value must be a number')
        else
          errors.add(range_attribute, 'To value must be greater than From value') unless range_to >  range_from
        end
      end
    end

    def cnd(x)
      a1, a2, a3, a4, a5 = 0.31938153, -0.356563782, 1.781477937, -1.821255978, 1.330274429
      l = x.abs
      k = 1.0 / (1.0 + 0.2316419 * l)
      w = 1.0 - 1.0 / Math.sqrt(2*Math::PI)*Math.exp(-l*l/2.0) * (a1*k + a2*k*k + a3*(k**3) + a4*(k**4) + a5*(k**5))
      w = 1.0 - w if x < 0
      return w
    end

    def calculate_black_scholes_value(values)
      s = values['stock_price']
      x = values['strike_price']
      t = values['years_to_maturity']
      r = values['risk_free_interest_rate'] / 100.0
      v = values['volatality']  / 100.0

      d1 = ( Math.log(s/x) + ( r + v*v/2.0)*t)/( v*Math.sqrt(t) )
      d2 = d1-v*Math.sqrt(t)
      if call_flag?
        return s*cnd(d1)-x*Math.exp(-r*t)*cnd(d2)
      else
        return x*Math.exp(-r*t)*cnd(-d2)-s*cnd(-d1)
      end
    end

end
